resource "aws_ssoadmin_account_assignment" "this" {
  depends_on = [aws_ssoadmin_customer_managed_policy_attachment.customer, aws_ssoadmin_managed_policy_attachment.managed]

  for_each = {
    for idx, assignment in local.flattened_assignments : "${assignment.group}_${assignment.permission_set}_${assignment.account}" => assignment
  }

  instance_arn       = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.managed[each.value.permission_set].arn

  principal_id   = aws_identitystore_group.this[each.value.group].group_id
  principal_type = "GROUP"

  target_id   = lookup(local.accounts, each.value.account, "")
  target_type = "AWS_ACCOUNT"
}
