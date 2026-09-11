# -----------------------------------------------------------------------------
# 1. Assume role policy document for EKS Pod Identity
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "eso_assume_role_document" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

# -----------------------------------------------------------------------------
# 2. Create IAM Role for External Secrets Operator
# -----------------------------------------------------------------------------
resource "aws_iam_role" "eso_role" {
  name               = "${var.project_name}-external-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.eso_assume_role_document.json
}

# -----------------------------------------------------------------------------
# 3. Create Policy Document for Secrets Manager
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "eso_secrets_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = [
      "arn:aws:secretsmanager:${var.region}:${data.aws_caller_identity.current.account_id}:secret:${var.project_name}/*"
    ]
  }
}

# -----------------------------------------------------------------------------
# 4. Create IAM Policy
# -----------------------------------------------------------------------------
resource "aws_iam_policy" "eso_secrets_policy" {
  name        = "${var.project_name}-external-secrets-policy"
  description = "Policy for External Secrets Operator to access Secrets Manager"
  policy      = data.aws_iam_policy_document.eso_secrets_policy_document.json
}

# -----------------------------------------------------------------------------
# 5. Attach Policy to IAM Role
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "eso_secrets_policy_attachment" {
  role       = aws_iam_role.eso_role.name
  policy_arn = aws_iam_policy.eso_secrets_policy.arn
}