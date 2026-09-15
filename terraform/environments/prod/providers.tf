terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    # Use the prod-backend.conf file to configure the backend
  }
}

provider "aws" {
  region = var.region
}