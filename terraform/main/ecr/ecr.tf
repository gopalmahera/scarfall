resource "aws_ecr_repository" "ecr" {
  for_each = { for repo_name, repo_config in local.ecr : repo_name => repo_config if repo_config.enable }

  name = each.key

  image_scanning_configuration {
    scan_on_push = false
  }

  encryption_configuration {
    encryption_type = each.value.encryption.enable && each.value.encryption.kms_key != "" ? "KMS" : "AES256"
    kms_key         = each.value.encryption.enable && each.value.encryption.kms_key != "" ? each.value.encryption.kms_key : ""
  }

  tags = merge(
    var.tags,
    local.tags,
    { "tf_module" = "ecr" }
  )
}

resource "aws_ecr_repository_policy" "crossaccount" {
  depends_on = [aws_ecr_repository.ecr]

  for_each   = { for repo_name, repo_config in local.ecr : repo_name => repo_config if repo_config.crossaccount_allow }
  repository = aws_ecr_repository.ecr[each.key].name
  policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::148761651852:root", # Dev
            "arn:aws:iam::321133955826:root", # Prod
          ]
        }
        Action = [
          "ecr:ListImages",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  })
}
