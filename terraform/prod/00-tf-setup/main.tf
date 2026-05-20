locals {
  prefix  = "scarfall"
  postfix = ""
}

locals {
  enabled_stages               = { for key, value in var.stages : key => value if value.enable }
  stages_with_multiple_remotes = { for key, value in local.enabled_stages : key => value if length(value.remote) > 0 }
}

resource "random_string" "suffix" {
  length      = 8
  lower       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 6
  special     = false
}

resource "aws_s3_bucket" "s3_terraform_state" {
  bucket = "${lower(local.prefix)}-terraform-state-${random_string.suffix.result}"
  lifecycle {
    ignore_changes = [bucket]
  }
}

resource "local_file" "terraform_plan" {
  for_each = local.enabled_stages
  content  = ""
  filename = "${path.module}/../${each.key}/plan/.gitkeep"
}

resource "local_file" "backend_config" {
  depends_on = [local_file.terraform_plan]
  for_each   = local.enabled_stages
  content = templatefile("${path.module}/extra/backend_template.tmpl", {
    bucket_name = aws_s3_bucket.s3_terraform_state.bucket
    key         = each.key
    profile     = var.aws_profile
    region      = aws_s3_bucket.s3_terraform_state.region
  })
  filename = "${path.module}/../${each.key}/backend.tf"
}

resource "local_file" "remote_config" {
  depends_on = [local_file.terraform_plan]
  for_each   = local.stages_with_multiple_remotes
  content = templatefile("${path.module}/extra/remote_template.tmpl", {
    bucket_name = aws_s3_bucket.s3_terraform_state.bucket
    key         = each.key
    remotes     = each.value.remote
    profile     = var.aws_profile
    region      = aws_s3_bucket.s3_terraform_state.region
  })
  filename = "${path.module}/../${each.key}/remote-state.tf"
}
