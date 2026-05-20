data "aws_ssoadmin_instances" "this" {}

resource "aws_identitystore_group" "this" {
  provider = aws.management

  for_each = { for group_name, group in var.groups : group_name => group if group.enable }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = each.value.display_name
  description  = each.value.description
}

resource "aws_identitystore_user" "this" {
  provider = aws.management

  for_each = { for email, user in var.users : email => user if user.enable }

  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  display_name = each.value.display_name
  user_name    = each.key

  name {
    given_name  = each.value.first_name
    family_name = each.value.last_name
  }

  emails {
    primary = true
    value   = each.value.email
  }
}

resource "aws_identitystore_group_membership" "this" {
  depends_on = [aws_identitystore_user.this, aws_identitystore_group.this]
  provider   = aws.management

  for_each          = { for association in local.user_group_associations : "${association.member_id}_${association.group_id}" => association }
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]

  group_id  = aws_identitystore_group.this[each.value.group_id].group_id
  member_id = aws_identitystore_user.this[each.value.member_id].user_id
}
