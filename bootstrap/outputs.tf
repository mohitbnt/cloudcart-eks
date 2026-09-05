# Output the name of the bucket
output "bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

# Output the name of the role
output "oidc_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}