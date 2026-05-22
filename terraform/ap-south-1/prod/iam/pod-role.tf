# Extract unique customer policies along with namespaces from pod_roles
locals {
  customer_policies = distinct(flatten([
    for name, config in local.pod_roles : [
      for policy in config.policy :
      policy.type == "customer" && config.enable == true ? [{ name = policy.name, namespace = config.namespace }] : []
    ]
  ]))

  customer_policies_filtered = [
    for policy in local.customer_policies : policy
    if policy != null
  ]


  managed_policies = distinct(flatten([
    for name, config in local.pod_roles : [
      for policy in config.policy :
      policy.type == "managed" && config.enable == true ? [{ name = policy.name, namespace = config.namespace }] : []
    ]
  ]))

  managed_policies_filtered = [
    for policy in local.managed_policies : policy
    if policy != null
  ]
}

data "aws_iam_policy" "managed_policy" {
  for_each = {
    for policy in local.managed_policies_filtered :
    policy.name => policy
  }
  name = each.key
}

# Dynamically create IAM policies for each unique customer policy with namespace
resource "aws_iam_policy" "pod_policy" {
  for_each = {
    for policy in local.customer_policies_filtered :
    "${policy.namespace}-${policy.name}" => policy
  }

  name        = "pod-policy-${var.region}-${each.value.namespace}-${each.value.name}"
  path        = "/"
  description = "Policy for ${each.value.name} service in namespace ${each.value.namespace}"

  policy = file("policy/${each.value.name}.json")

  tags = merge(
    var.tags,
    { "tf_module" = "aws_iam_policy_pod_policy" }
  )
}

module "eks_role_pod" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.2.3"

  for_each = {
    for name, config in local.pod_roles : name => config
    if config.enable
  }

  # Role configuration
  create             = true
  enable_oidc        = true
  use_name_prefix    = false
  name               = "pod-role-${var.region}-${each.value.namespace}-${each.key}"
  oidc_provider_urls = [data.terraform_remote_state.eks.outputs.oidc_provider]

  # Configure OIDC subjects for Kubernetes service accounts
  # This determines which service accounts can assume this role
  oidc_subjects = concat(
    ["sts.amazonaws.com"],
    [
      for service_account in try(each.value.service_account, []) :
      "system:serviceaccount:${each.value.namespace}:${each.key}"
    ]
  )

  # Attach IAM policies to the role
  # Supports both customer-defined and AWS-managed policies
  policies = {
    for policy in each.value.policy :
    policy.name => policy.type == "customer" ?
    aws_iam_policy.pod_policy["${each.value.namespace}-${policy.name}"].arn :
    data.aws_iam_policy.managed_policy[policy.name].arn
  }

  tags = merge(
    var.tags,
    { "tf_module" = "eks_role_pod" }
  )
}
