# --------------------------------------------------------------------------------
# Publish Terraform State Bucket
# --------------------------------------------------------------------------------
output "bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

# --------------------------------------------------------------------------------
# Publish IAM Role for GitHub Actions
# --------------------------------------------------------------------------------
output "oidc_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}

# --------------------------------------------------------------------------------
# Publish TLS Certificate ARN
# --------------------------------------------------------------------------------
output "tls_certificate_arn" {
  description = "The ARN of the TLS certificate"
  value       = aws_acm_certificate.tls_certificate.arn
}