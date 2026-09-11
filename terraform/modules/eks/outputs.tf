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

# --------------------------------------------------------------------------------
# 3. Publish EKS Cluster certificate authority data
# --------------------------------------------------------------------------------
output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.main_eks_cluster.certificate_authority[0].data
}