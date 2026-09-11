# --------------------------------------------------------------------------------
# 1. Publish VPC Endpoint Security Group ID
# --------------------------------------------------------------------------------
output "vpc_endpoint_sg_id" {
  value = aws_security_group.vpc_endpoint_sg.id
}

# --------------------------------------------------------------------------------
# 2. Publish RDS Security Group ID
# --------------------------------------------------------------------------------
output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

# --------------------------------------------------------------------------------
# 3. Publish Redis Security Group ID
# --------------------------------------------------------------------------------
output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}

# --------------------------------------------------------------------------------
# 4. Publish EKS Cluster Security Group ID
# --------------------------------------------------------------------------------
output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}

# --------------------------------------------------------------------------------
# 5. Publish EKS Worker Security Group ID
# --------------------------------------------------------------------------------
output "eks_worker_sg_id" {
  value = aws_security_group.eks_worker_sg.id
}