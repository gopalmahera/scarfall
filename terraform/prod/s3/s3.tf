resource "aws_s3_bucket" "this" {
  for_each      = { for bucket in local.s3_buckets : bucket.bucket_name => bucket }
  bucket        = each.value.bucket_name
  force_destroy = false
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = { for bucket in local.s3_buckets : bucket.bucket_name => bucket }
  bucket   = aws_s3_bucket.this[each.key].id
  rule {
    bucket_key_enabled = each.value.bucket_key_enabled
    apply_server_side_encryption_by_default {
      kms_master_key_id = each.value.kms_master_key_id
      sse_algorithm     = each.value.sse_algorithm
    }
  }
  depends_on = [aws_s3_bucket.this]
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = { for bucket in local.s3_buckets : bucket.bucket_name => bucket }
  bucket   = aws_s3_bucket.this[each.key].id
  versioning_configuration {
    status = each.value.versioning
    #mfa_delete = "Disabled" 
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = { for bucket in local.s3_buckets : bucket.bucket_name => bucket }
  bucket   = aws_s3_bucket.this[each.key].id

  block_public_acls       = each.value.block_public_acls
  block_public_policy     = each.value.block_public_policy
  ignore_public_acls      = each.value.ignore_public_acls
  restrict_public_buckets = each.value.restrict_public_buckets
}

resource "aws_s3_bucket_policy" "this" {
  for_each = {
    for bucket in local.s3_buckets : bucket.bucket_name => bucket
    if bucket.policy_enabled
  }
  bucket = aws_s3_bucket.this[each.key].id
  policy = each.value.policy_file != "" ? file(each.value.policy_file) : null
}


locals {
  # Filter lifecycle rules for buckets where lifecycle is true
  lifecycle_rules_us = {
    for bucket in local.s3_buckets :
    bucket.bucket_name => jsondecode(file("./bucket_lifecycle/${bucket.bucket_name}_lifecycle.json"))
    if bucket.lifecycle
  }
}



resource "aws_s3_bucket_lifecycle_configuration" "this" {
  for_each = { for bucket in local.s3_buckets : bucket.bucket_name => bucket if bucket.lifecycle }
  bucket   = each.value.bucket_name

  dynamic "rule" {
    for_each = lookup(local.lifecycle_rules_us, each.key, [])
    content {
      id     = rule.value.ID
      status = rule.value.Status

      dynamic "filter" {
        for_each = contains(keys(rule.value), "Filter") && length(keys(rule.value.Filter)) > 0 ? [1] : []
        content {
          prefix = lookup(rule.value.Filter, "Prefix", null)
        }
      }

      dynamic "transition" {
        for_each = contains(keys(rule.value), "Transitions") ? rule.value.Transitions : []
        content {
          days          = transition.value.Days
          storage_class = transition.value.StorageClass
        }
      }

      dynamic "expiration" {
        for_each = contains(keys(rule.value), "Expiration") ? [1] : []
        content {
          days = lookup(rule.value.Expiration, "Days", null)
        }
      }
    }
  }
}
