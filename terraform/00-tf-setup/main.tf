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
  special     = true

  lifecycle {
    ignore_changes = [
      length,
      min_numeric,
      min_lower
    ]
  }
}

resource "aws_s3_bucket" "s3_terraform_state" {
  bucket              = "scarfall-terraform-central"
  object_lock_enabled = true
  lifecycle {
    ignore_changes = [bucket]
  }

  tags = merge(
    var.tags,
    { "tf_module" = "tf-setup", "Name" = "${lower(local.prefix)}-terraform-state-${random_string.suffix.result}" }
  )
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.s3_terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Add server-side encryption for the main S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.s3_terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to S3 buckets
resource "aws_s3_bucket_public_access_block" "s3_terraform_state" {
  bucket = aws_s3_bucket.s3_terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_terraform_state_bucket_policy" {
  bucket = aws_s3_bucket.s3_terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [

      {
        Sid    = "AllowRootAccount"
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::300906349855:root"
        }

        Action = "s3:*"

        Resource = [
          aws_s3_bucket.s3_terraform_state.arn,
          "${aws_s3_bucket.s3_terraform_state.arn}/*"
        ]
      },

      {
        Sid    = "TFAllowDevS3Access"
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::148761651852:role/aws-reserved/sso.amazonaws.com/ap-south-1/AWSReservedSSO_Administrator-Access_ee835b5e188eb431"
        }

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]

        Resource = [
          aws_s3_bucket.s3_terraform_state.arn,
          "${aws_s3_bucket.s3_terraform_state.arn}/*"
        ]
      },

      {
        Sid    = "TFAllowProS3Access"
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::321133955826:role/aws-reserved/sso.amazonaws.com/ap-south-1/AWSReservedSSO_Administrator-Access_2317261556563977"
        }

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]

        Resource = [
          aws_s3_bucket.s3_terraform_state.arn,
          "${aws_s3_bucket.s3_terraform_state.arn}/*"
        ]
      },
    ]
  })
}

resource "local_file" "terraform_plan" {
  for_each = local.enabled_stages

  content = ""

  filename = "${path.module}/../${each.value.region}/${each.value.environment}/${each.value.folder}/plan/.gitkeep"
}

#### create backend and remote state config files #####

resource "local_file" "backend_config" {
  depends_on = [local_file.terraform_plan]

  for_each = local.enabled_stages

  content = templatefile("${path.module}/extra/backend_template.tmpl", {
    bucket_name = "scarfall-terraform-central"
    account     = each.value.environment
    key         = each.value.folder
    profile     = var.environments[each.value.environment].profile
    region      = each.value.region
  })

  filename = "${path.module}/../${each.value.region}/${each.value.environment}/${each.value.folder}/backend.tf"
}

resource "local_file" "remote_config" {
  depends_on = [local_file.terraform_plan]

  for_each = local.stages_with_multiple_remotes

  content = templatefile("${path.module}/extra/remote_template.tmpl", {
    bucket_name = "scarfall-terraform-central"
    account     = each.value.environment
    remotes     = [for r in each.value.remote : split("_", r)[1]]
    profile     = var.environments[each.value.environment].profile
    region      = each.value.region
  })

  filename = "${path.module}/../${each.value.region}/${each.value.environment}/${each.value.folder}/remote-state.tf"
}
