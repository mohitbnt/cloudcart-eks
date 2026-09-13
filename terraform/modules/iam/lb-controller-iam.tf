# -----------------------------------------------------------------------------
# 1. Create IAM Role for AWS Load Balancer Controller
# -----------------------------------------------------------------------------
resource "aws_iam_role" "lb_controller_role" {
  name               = "${var.project_name}-aws-load-balancer-controller-role"
  assume_role_policy = data.aws_iam_policy_document.pods_assume_role_document.json
}

# -----------------------------------------------------------------------------
# 2. Create IAM Policy
# -----------------------------------------------------------------------------
resource "aws_iam_policy" "lb_controller_policy" {
  name        = "${var.project_name}-aws-load-balancer-controller-policy"
  description = "Native data-block policy for AWS Load Balancer Controller to manage ALBs/NLBs"
  policy      = file("${path.module}/lb-controller-policy.json")
}

# -----------------------------------------------------------------------------
# 3. Attach Policy to IAM Role
# -----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "lb_controller_policy_attachment" {
  role       = aws_iam_role.lb_controller_role.name
  policy_arn = aws_iam_policy.lb_controller_policy.arn
}
