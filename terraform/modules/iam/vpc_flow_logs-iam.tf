# ----------------------------------------------------------------------
# 1. Create IAM role for VPC Flow Logs
# ----------------------------------------------------------------------
data "aws_iam_policy_document" "vpc_flow_logs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

# ----------------------------------------------------------------------
# 2. Create IAM role for VPC Flow Logs
# ----------------------------------------------------------------------
resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = "${var.project_name}-vpc-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role_policy.json
}

# ----------------------------------------------------------------------
# 3. Create policy document for VPC Flow Logs
# ----------------------------------------------------------------------
data "aws_iam_policy_document" "vpc_flow_logs_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/vpc/${var.project_name}-vpc-flow-logs:*"]
  }
}

# ----------------------------------------------------------------------
# 4. Create IAM policy for VPC Flow Logs
# ----------------------------------------------------------------------
resource "aws_iam_policy" "vpc_flow_logs_policy" {
  name   = "${var.project_name}-vpc-flow-logs-policy"
  policy = data.aws_iam_policy_document.vpc_flow_logs_policy.json
}

# ----------------------------------------------------------------------
# 5. Attach IAM policy to IAM role for VPC Flow Logs
# ----------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "vpc_flow_logs_policy_attachment" {
  role       = aws_iam_role.vpc_flow_logs_role.name
  policy_arn = aws_iam_policy.vpc_flow_logs_policy.arn
}