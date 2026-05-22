resource "random_string" "random" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}

data "http" "eks_ebs_csi_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/${var.release}/docs/example-iam-policy.json"
  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-${var.name}-${random_string.random.result}"
  description = "${var.cluster_name}-${var.name}-${random_string.random.result}"
  path        = "/"
  policy      = data.http.eks_ebs_csi_policy.response_body

  tags = merge(
    { "Name" = "${var.cluster_name}-${var.name}" },
    { "custom-module" = "eks-ebs-csi" }
  )
}

module "eks_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.28"

  create_role  = true
  role_name    = "${var.cluster_name}-${var.name}-${random_string.random.result}"
  provider_url = var.oidc_provider

  oidc_fully_qualified_subjects = [
    "sts.amazonaws.com",
    "system:serviceaccount:${var.namespace}:${var.name}"
  ]

  role_policy_arns = [
    "${aws_iam_policy.this.arn}",
  ]

  number_of_role_policy_arns = 1

  tags = merge(
    { "Name" = "${var.cluster_name}-${var.name}" },
    { "custom-module" = "eks-ebs-csi" }
  )
}

locals {
  vars = {
    name = var.name
    role = module.eks_role.iam_role_arn
  }
  values = templatefile(
    "${path.module}/helm-values.tmpl",
    local.vars
  )
}

resource "helm_release" "eks_ebs_csi_helm" {
  depends_on = [module.eks_role]
  name       = var.name
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver/"
  chart      = "aws-ebs-csi-driver"
  namespace  = var.namespace
  version    = var.helmversion
  values     = [local.values]
}

resource "kubernetes_storage_class" "eks_ebs_csi_class_ext4" {
  depends_on = [helm_release.eks_ebs_csi_helm]
  metadata {
    name = "ebs-sc-ext4"
  }
  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
  parameters = {
    fstype : "ext4"
    type : "gp3"
    iops : var.ext4_iops
    throughput : var.ext4_throughput
    encrypted : var.ext4_encrypted
    tagSpecification_1 : "Name={{ .PVCName }}"
  }
}

resource "kubernetes_storage_class" "eks_ebs_csi_class_ntfs" {
  depends_on = [helm_release.eks_ebs_csi_helm]
  metadata {
    name = "ebs-sc-ntfs"
  }
  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
  parameters = {
    fstype : "ntfs"
    type : "gp3"
    iops : var.ntfs_iops
    throughput : var.ntfs_throughput
    encrypted : var.ntfs_encrypted
    tagSpecification_1 : "Name={{ .PVCName }}"
  }
}
