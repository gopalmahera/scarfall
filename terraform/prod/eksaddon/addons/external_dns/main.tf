resource "random_string" "random" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}

resource "random_string" "private" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}

resource "random_string" "public" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}


resource "aws_iam_policy" "this" {
  count       = var.public_role == null || var.private_role == null ? 1 : 0
  name        = "${var.cluster_name}-externaldns-r53-${random_string.random.result}"
  path        = "/"
  description = "${var.cluster_name}-externaldns-r53-${random_string.random.result}"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["route53:ChangeResourceRecordSets"],
        "Resource" : ["arn:aws:route53:::hostedzone/*"]
      },
      {
        "Effect" : "Allow",
        "Action" : ["route53:ListHostedZones", "route53:ListResourceRecordSets"],
        "Resource" : ["*"]
      }
    ]
  })

  tags = merge(
    { "Name" = "${var.cluster_name}-externaldns-r53" },
    { "custom-module" = "eks-externaldns" }
  )
}

module "dns" {
  count   = var.public_role == null || var.private_role == null ? 1 : 0
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.28"

  create_role  = true
  role_name    = "${var.cluster_name}-externaldns-r53-${random_string.random.result}"
  provider_url = var.oidc_provider

  oidc_fully_qualified_subjects = [
    "sts.amazonaws.com",
    "system:serviceaccount:${var.namespace}:${var.public_saname}",
    "system:serviceaccount:${var.namespace}:${var.private_saname}",
  ]

  role_policy_arns = [
    "${aws_iam_policy.this[0].arn}",
  ]

  number_of_role_policy_arns = 1

  tags = merge(
    { "Name" = "${var.cluster_name}-externaldns-r53" },
    { "custom-module" = "eks-externaldns" }
  )
}

locals {
  private_vars = {
    name       = var.name
    zoneType   = "private"
    saname     = var.private_saname
    zone       = var.private_zone
    domain     = var.private_domain
    policy     = var.private_policy
    role       = var.private_role == null ? module.dns[0].iam_role_arn : var.private_role
    txtOwnerId = random_string.private.result
  }
  public_vars = {
    name       = var.name
    zoneType   = "public"
    saname     = var.public_saname
    zone       = var.public_zone
    domain     = var.public_domain
    policy     = var.public_policy
    role       = var.public_role == null ? module.dns[0].iam_role_arn : var.public_role
    txtOwnerId = random_string.public.result
  }
  private_values = templatefile(
    "${path.module}/helm-values.tmpl",
    local.private_vars
  )
  public_values = templatefile(
    "${path.module}/helm-values.tmpl",
    local.public_vars
  )
}

resource "helm_release" "private" {
  count            = var.private_dns_enable ? 1 : 0
  depends_on       = [module.dns]
  name             = "${var.name}-private"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = var.namespace
  version          = var.helmversion
  create_namespace = true
  values           = [local.private_values]
}

resource "helm_release" "public" {
  count            = var.public_dns_enable ? 1 : 0
  depends_on       = [module.dns]
  name             = "${var.name}-public"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  namespace        = var.namespace
  version          = var.helmversion
  create_namespace = true
  values           = [local.public_values]
}
