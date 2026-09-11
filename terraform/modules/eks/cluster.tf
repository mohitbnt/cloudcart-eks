# -----------------------------------------------------------------------------
# Create EKS cluster
# -----------------------------------------------------------------------------
resource "aws_eks_cluster" "main_eks_cluster" {
  name     = "${var.project_name}-eks-cluster"
  role_arn = var.eks_cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [var.eks_cluster_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true

    public_access_cidrs = var.public_access_cidr
  }

  depends_on = [var.eks_cluster_role_arn]
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-eks-cluster"
  })
}