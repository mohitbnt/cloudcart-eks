# -----------------------------------------------------------------------------
# 1. Create assume role policy document for EBS CSI role
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "assume_ebs_csi_role_policy" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

# -----------------------------------------------------------------------------
# 2. Create EBS CSI role
# -----------------------------------------------------------------------------
resource "aws_iam_role" "ebs_csi_role" {
  name               = "${var.project_name}-ebs-csi-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ebs_csi_role_policy.json
}

# -----------------------------------------------------------------------------
# 3. Attach EBS CSI policy to EBS CSI role
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ebs_csi_policy_attachment" {
  role       = aws_iam_role.ebs_csi_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}