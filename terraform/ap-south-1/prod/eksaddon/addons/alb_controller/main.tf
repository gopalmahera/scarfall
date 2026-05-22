resource "random_string" "suffix" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}

data "http" "eks_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${var.release}/docs/install/iam_policy.json"
  request_headers = {
    Accept = "application/json"
  }
}

data "http" "eks_additional_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${var.release}/docs/install/iam_policy_v1_to_v2_additional.json"
  request_headers = {
    Accept = "application/json"
  }
}

data "http" "crdi" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/${var.release}/helm/aws-load-balancer-controller/crds/crds.yaml"
  request_headers = {
    Accept = "application/yaml"
  }
}

resource "kubectl_manifest" "crdi" {
  yaml_body = data.http.crdi.response_body
}

resource "aws_iam_policy" "eks_policy" {
  name        = "${var.cluster_name}-AWSLoadBalancerControllerIAMPolicy-${random_string.suffix.result}"
  path        = "/"
  description = "AWS LoadBalancer Controller IAM Policy"
  policy      = data.http.eks_policy.response_body
  tags = merge(
    var.tags,
    { "custom-module" = "eks-alb-controller" }
  )
}

resource "aws_iam_policy" "eks_additional_policy" {
  depends_on  = [aws_iam_policy.eks_policy]
  name        = "${var.cluster_name}-AWSLoadBalancerControllerAdditionalIAMPolicy-${random_string.suffix.result}"
  path        = "/"
  description = "AWS LoadBalancer Controller Additional IAM Policy"
  policy      = data.http.eks_additional_policy.response_body
  tags = merge(
    var.tags,
    { "custom-module" = "eks-alb-controller" }
  )
}

module "eks_role" {
  depends_on = [aws_iam_policy.eks_policy, aws_iam_policy.eks_additional_policy, kubectl_manifest.crdi]
  source     = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version    = "~> 5.48"

  create_role  = true
  role_name    = "${var.cluster_name}-AWSLoadBalancerControllerIAMRole"
  provider_url = var.oidc_provider
  oidc_fully_qualified_subjects = [
    "sts.amazonaws.com",
    "system:serviceaccount:${var.namespace}:${var.name}"
  ]
  role_policy_arns = [
    "${aws_iam_policy.eks_policy.arn}",
    "${aws_iam_policy.eks_additional_policy.arn}",
  ]
  number_of_role_policy_arns = 2

  tags = merge(
    var.tags,
    { "tf_module" = "eks_role" }
  )
}

locals {
  vars = {
    name         = var.name
    cluster_name = var.cluster_name
    role         = module.eks_role.iam_role_arn
  }
  values = templatefile(
    "${path.module}/helm-values.tmpl",
    local.vars
  )
}

resource "helm_release" "this" {
  depends_on       = [module.eks_role, kubectl_manifest.crdi]
  name             = var.name
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  version          = var.helmversion
  namespace        = var.namespace
  create_namespace = true
  values           = [local.values]
}
