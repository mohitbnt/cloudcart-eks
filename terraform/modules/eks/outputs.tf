# --------------------------------------------------------------------------------
# 1. Publish EKS Cluster name
# --------------------------------------------------------------------------------
output "cluster_name" {
  value = aws_eks_cluster.main_eks_cluster.name
}

# --------------------------------------------------------------------------------
# 2. Publish EKS Cluster endpoint
# --------------------------------------------------------------------------------
output "cluster_endpoint" {
  value = aws_eks_cluster.main_eks_cluster.endpoint
}