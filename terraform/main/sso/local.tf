locals {

  tags = { "tf_state" = "sso" }

  accounts = {
    management = "300906349855"
    dev        = "148761651852"
    prod       = "321133955826"
  }

  user_group_associations = flatten([
    for key, user in var.users : [
      for group_name in user.group : {
        member_id = key
        group_id  = group_name
      }
    ]
  ])

  policy_arn_associations = flatten([
    for ps_key, ps_value in var.permission_set : [
      for policy in ps_value.attachment : {
        permission_set_name = ps_key
        policy              = policy.policy
        policy_arn          = policy.type == "managed" ? "arn:aws:iam::aws:policy/${policy.policy}" : null
        customer_policy_arn = policy.type == "customer" ? policy.policy : null
      }
      if policy.type == "managed" || policy.type == "customer"
    ]
  ])


  flattened_assignments = flatten([
    for group, assignments in var.group_account_assignment : [
      for assignment in assignments : {
        group          = group
        permission_set = assignment.permission_set
        account        = assignment.account
      }
    ]
  ])
}
