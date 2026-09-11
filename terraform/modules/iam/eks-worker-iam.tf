# -----------------------------------------------------------------------------
# 1. Create assume role policy document for EKS worker role
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "assume_worker_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# -----------------------------------------------------------------------------
# 2. Create EKS worker role
# -----------------------------------------------------------------------------
resource "aws_iam_role" "eks_worker_role" {
  name               = "${var.project_name}-eks-worker-role"
  assume_role_policy = data.aws_iam_policy_document.assume_worker_role_policy.json
}

# -----------------------------------------------------------------------------
# 3. Attach EKS worker policy to EKS worker role
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_worker_policy_attachment" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# -----------------------------------------------------------------------------
# 4. Attach AmazonEKS_CNI_Policy to EKS worker role
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ----------------------------------------------------------------------------- 
# 5. Attach AmazonEC2ContainerRegistryReadOnly to EKS worker role
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# -----------------------------------------------------------------------------
# 6. Attach AmazonSSMManagedInstanceCore for SSM Agent
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}