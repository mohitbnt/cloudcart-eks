# --------------------------------------------------------------------------------
# 1. Publish EKS Cluster name
# --------------------------------------------------------------------------------
output "eks_cluster_name" {
  value = aws_eks_cluster.main_eks_cluster.name
}