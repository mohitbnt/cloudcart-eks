# --------------------------------------------------------------------------------
# Fetch RDS SG, Redis SG and Private Subnet IDs from the core-infra state file
# --------------------------------------------------------------------------------

data "terraform_remote_state" "core_infra" {
  backend = "s3"

  config = {
    bucket = "repo-1358538824-tfstate"
    key    = "cloudcart-eks/core-infra/terraform.tfstate"
    region = "us-east-1"
  }
}