locals {
  s3_buckets = [
    {
      bucket_name             = "scarfall-prod-loki-chunks"
      kms_master_key_id       = ""
      sse_algorithm           = "AES256"
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
      policy_enabled          = false
      policy_file             = ""
      versioning              = "Disabled"
      lifecycle               = false
      bucket_key_enabled      = true
    },
    {
      bucket_name             = "scarfall-prod-game-data"
      kms_master_key_id       = ""
      sse_algorithm           = "AES256"
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
      policy_enabled          = false
      policy_file             = ""
      versioning              = "Disabled"
      lifecycle               = false
      bucket_key_enabled      = true
    },
  ]
}
