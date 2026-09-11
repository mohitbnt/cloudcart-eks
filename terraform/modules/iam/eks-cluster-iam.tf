# -----------------------------------------------------------------------------
# 1. Create assume role policy document for EKS cluster role
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "assume_eks_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# -----------------------------------------------------------------------------
# 2. Create EKS cluster role
# -----------------------------------------------------------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.project_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.assume_eks_role_policy.json
}

# -----------------------------------------------------------------------------
# 3. Attach EKS cluster policy to EKS cluster role
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}