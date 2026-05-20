resource "random_string" "random" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}

data "http" "eks_efs_csi_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/${var.release}/docs/iam-policy-example.json"
  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.cluster_name}-${var.name}-${random_string.random.result}"
  description = "${var.cluster_name}-${var.name}-${random_string.random.result}"
  path        = "/"
  policy      = data.http.eks_efs_csi_policy.response_body

  tags = merge(
    { "Name" = "${var.cluster_name}-${var.name}" },
    { "custom-module" = "eks-efs-csi" }
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
    { "custom-module" = "eks-efs-csi" }
  )
}

locals {
  vars = {
    name   = var.name
    role   = module.eks_role.iam_role_arn
    region = var.region
  }
  values = templatefile(
    "${path.module}/helm-values.tmpl",
    local.vars
  )
}

resource "helm_release" "eks_efs_csi_helm" {
  depends_on = [module.eks_role]
  name       = var.name
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = var.namespace
  version    = var.helmversion
  values     = [local.values]
}

resource "kubernetes_storage_class" "eks_efs_csi_class_helm" {
  depends_on = [helm_release.eks_efs_csi_helm]
  metadata {
    name = "efs-sc"
  }
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Retain"
  parameters = {
    type             = "pd-standard"
    provisioningMode = "efs-ap"
    fileSystemId     = var.efs_id
    directoryPerms   = "700"
    gidRangeStart    = "1000"
    gidRangeEnd      = "2000"
    basePath         = "/"
  }
  # mount_options = ["file_mode=0700", "dir_mode=0777", "mfsymlinks", "uid=1000", "gid=1000", "nobrl", "cache=none"]
}

# resource "kubernetes_storage_class" "eks_ebs_csi_class_ext4" {
#   depends_on = [helm_release.eks_ebs_csi_helm]
#   metadata {
#     name = "ebs-sc-ext4"
#   }
#   storage_provisioner    = "ebs.csi.aws.com"
#   reclaim_policy         = "Delete"
#   allow_volume_expansion = true
#   volume_binding_mode    = "WaitForFirstConsumer"
#   parameters = {
#     fstype : "ext4"
#     type : "gp3"
#     iops : var.ext4_iops
#     throughput : var.ext4_throughput
#     encrypted : var.ext4_encrypted
#     tagSpecification_1 : "Name={{ .PVCName }}"
#   }
# }

# resource "kubernetes_storage_class" "eks_ebs_csi_class_ntfs" {
#   depends_on = [helm_release.eks_ebs_csi_helm]
#   metadata {
#     name = "ebs-sc-ntfs"
#   }
#   storage_provisioner    = "ebs.csi.aws.com"
#   reclaim_policy         = "Delete"
#   allow_volume_expansion = true
#   volume_binding_mode    = "WaitForFirstConsumer"
#   parameters = {
#     fstype : "ntfs"
#     type : "gp3"
#     iops : var.ntfs_iops
#     throughput : var.ntfs_throughput
#     encrypted : var.ntfs_encrypted
#     tagSpecification_1 : "Name={{ .PVCName }}"
#   }
# }
