resource "aws_iam_policy" "customer_managed_management" {
  provider = aws.management

  for_each = {
    for key, policy in var.customer_managed_policy : key => policy
    if lookup(policy, "account", []) != [] && contains(policy.account, "management")
  }

  name        = each.value.name
  description = each.value.description
  policy      = file("policy/${each.value.file}")

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "permission_set" }
  )
}

resource "aws_iam_policy" "customer_managed_dev" {
  provider = aws.dev

  for_each = {
    for key, policy in var.customer_managed_policy : key => policy
    if lookup(policy, "account", []) != [] && contains(policy.account, "dev")
  }

  name        = each.value.name
  description = each.value.description
  policy      = file("policy/${each.value.file}")

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "permission_set" }
  )
}

resource "aws_ssoadmin_permission_set" "managed" {
  provider = aws.management

  for_each = var.permission_set

  name             = each.value.name
  instance_arn     = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  description      = each.value.description
  session_duration = each.value.session_duration

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "permission_set" }
  )
}

resource "aws_ssoadmin_managed_policy_attachment" "managed" {
  provider = aws.management

  for_each = { for association in local.policy_arn_associations : "${association.permission_set_name}_${association.policy}" => association if association.policy_arn != null }

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.managed[each.value.permission_set_name].arn
  managed_policy_arn = each.value.policy_arn
}

resource "aws_ssoadmin_customer_managed_policy_attachment" "customer" {
  depends_on = [aws_iam_policy.customer_managed_management, aws_iam_policy.customer_managed_dev]
  provider   = aws.management

  for_each = { for association in local.policy_arn_associations : "${association.permission_set_name}_${association.policy}" => association if association.customer_policy_arn != null }

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.managed[each.value.permission_set_name].arn

  customer_managed_policy_reference {
    name = each.value.customer_policy_arn
    path = "/"
  }
}
