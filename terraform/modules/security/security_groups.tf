# -----------------------------------------------------------
# 1. Create security group for RDS and ElastiCache
# -----------------------------------------------------------

resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "Security group for RDS Instance."
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-rds-sg"
  })
}

resource "aws_security_group" "redis_sg" {
  name        = "${var.project_name}-redis-sg"
  description = "Security group for Redis Elasticache."
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-redis-sg"
  })
}

# -----------------------------------------------------------
# 2. Create security group for VPC endpoints
# -----------------------------------------------------------

resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${var.project_name}-vpc-endpoint-sg"
  description = "Security group for VPC endpoints."
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vpc-endpoint-sg"
  })
}

# -----------------------------------------------------------
# 3. Create security group for EKS cluster
# -----------------------------------------------------------

resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.project_name}-eks-cluster-sg"
  description = "Security group for EKS cluster (control plane)."
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-eks-cluster-sg"
  })
}

# ----------------------------------------------------------- 
# 4. Create security group for EKS worker nodes
# -----------------------------------------------------------

resource "aws_security_group" "eks_worker_sg" {
  name        = "${var.project_name}-eks-worker-sg"
  description = "Security group for EKS worker nodes."
  vpc_id      = var.vpc_id
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-eks-worker-sg"
  })
}