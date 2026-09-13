data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "pods_assume_role_document" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}