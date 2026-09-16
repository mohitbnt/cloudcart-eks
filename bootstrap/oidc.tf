# Create OIDC provider
resource "aws_iam_openid_connect_provider" "github_oidc_provider" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

# Trust policy for the IAM role
data "aws_iam_policy_document" "github_actions_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_oidc_provider.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_repo_path}:ref:${var.github_branch}",
        "repo:${var.github_repo_path}:pull_request"
      ]
    }
  }
}

# Create IAM role for Github Actions
resource "aws_iam_role" "github_actions_role" {
  name               = var.github_oidc_role
  assume_role_policy = data.aws_iam_policy_document.github_actions_trust.json
}

# Attach policy to the role
resource "aws_iam_role_policy_attachment" "github_actions_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}