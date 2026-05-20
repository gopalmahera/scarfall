
output "region" {
  value = aws_s3_bucket.s3_terraform_state[*].region
}
