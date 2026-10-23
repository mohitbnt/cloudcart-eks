# --------------------------------------------------------------------------------
# 1. Publish Private Subnet IDs
# --------------------------------------------------------------------------------
output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}

output "data_subnet_ids" {
  value = module.networking.data_subnet_ids
}

# --------------------------------------------------------------------------------
# 2. Publish RDS Security Group ID
# --------------------------------------------------------------------------------
output "rds_sg_id" {
  value = module.security.rds_sg_id
}

# --------------------------------------------------------------------------------
# 3. Publish Redis Security Group ID
# --------------------------------------------------------------------------------
output "redis_sg_id" {
  value = module.security.redis_sg_id
}

# --------------------------------------------------------------------------------
# 4. Publish EKS Cluster Name
# --------------------------------------------------------------------------------
output "cluster_name" {
  value = module.eks.cluster_name
}

# --------------------------------------------------------------------------------
# 5. Publish VPC ID
# --------------------------------------------------------------------------------
output "vpc_id" {
  value = module.networking.vpc_id
}

# --------------------------------------------------------------------------------
# Publish ECR registry URL and repository URLs
# --------------------------------------------------------------------------------
output "ecr_registry_url" {
  value = module.ecr.registry_url
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}
