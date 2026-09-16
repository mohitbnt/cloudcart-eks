# -----------------------------------------------------------------------------
# 1. Create EKS cluster
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

    public_access_cidrs = local.all_allowed_cidrs
  }

  access_config {
    authentication_mode = "API"
  }

  depends_on = [var.eks_cluster_role_arn]
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-eks-cluster"
  })
}

# -----------------------------------------------------------------------------
# 2. Create EKS Acccess Entry
# -----------------------------------------------------------------------------
resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.main_eks_cluster.name
  principal_arn = var.eks_admin_principal_arn
  type          = "STANDARD"
}

# -----------------------------------------------------------------------------
# 3. Associate EKS access policy
# -----------------------------------------------------------------------------
resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.main_eks_cluster.name
  principal_arn = aws_eks_access_entry.admin.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}