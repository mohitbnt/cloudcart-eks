# =============================================================================
# Bootstrap Configuration
# =============================================================================

variable "project" {
  type        = string
  description = "Project name used by the bootstrap resources."
}

variable "region" {
  type        = string
  description = "AWS region where the bootstrap resources are deployed."
  default     = "us-east-1"
}

# =============================================================================
# Terraform State
# =============================================================================

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket used for Terraform remote state."
  default     = "repo-tfstate"
}

# =============================================================================
# GitHub Actions OIDC
# =============================================================================

variable "github_oidc_role" {
  type        = string
  description = "Name of the IAM role for GitHub Actions OIDC."
}

variable "github_repo_path" {
  type        = string
  description = "GitHub repository path used in the OIDC trust policy."
}

variable "github_branch" {
  type        = string
  description = "GitHub branch reference used in the OIDC trust policy."
  default     = "refs/heads/main"
}
