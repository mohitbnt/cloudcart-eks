output "repository_urls" {
  description = "Map of service name to ECR repository URL"
  value       = { for name, repo in aws_ecr_repository.service : name => repo.repository_url }
}

output "registry_url" {
  description = "ECR registry host (<account>.dkr.ecr.<region>.amazonaws.com); use as global.imageRegistry in Helm values"
  value       = split("/", values(aws_ecr_repository.service)[0].repository_url)[0]
}
