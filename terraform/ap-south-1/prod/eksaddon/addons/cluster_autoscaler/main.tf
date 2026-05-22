resource "random_string" "random" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}

resource "aws_iam_policy" "eks_policy" {
  name        = "${var.cluster_name}-ClusterAutoscaler-${random_string.random.result}"
  path        = "/"
  description = "${var.cluster_name}-ClusterAutoscaler-${random_string.random.result}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "ec2:DescribeImages",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ],
        "Resource" : ["*"]
      }
    ]
  })
  tags = merge(
    { "tf_module" = "eks_cluster_autoscaler" }
  )
}


module "eks_role" {
  depends_on = [aws_iam_policy.eks_policy]
  source     = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version    = "~> 5.48"

  create_role  = true
  role_name    = "${var.cluster_name}-ClusterAutoscaler-${random_string.random.result}"
  provider_url = var.oidc_provider
  oidc_fully_qualified_subjects = [
    "sts.amazonaws.com",
    "system:serviceaccount:${var.namespace}:${var.name}"
  ]
  role_policy_arns = [
    "${aws_iam_policy.eks_policy.arn}",
  ]
  number_of_role_policy_arns = 1

  tags = merge(
    { "tf_module" = "eks_cluster_autoscaler" }
  )
}


locals {
  vars = {
    name         = var.name
    cluster_name = var.cluster_name
    region       = var.region
    role         = module.eks_role.iam_role_arn
  }
  values = templatefile(
    "${path.module}/helm-values.tmpl",
    local.vars
  )
}

resource "helm_release" "cluster_autoscaler" {
  depends_on       = [module.eks_role]
  name             = var.name
  repository       = "https://kubernetes.github.io/autoscaler"
  chart            = "cluster-autoscaler"
  namespace        = var.namespace
  create_namespace = true
  version          = var.helmversion
  values           = [local.values]
}
