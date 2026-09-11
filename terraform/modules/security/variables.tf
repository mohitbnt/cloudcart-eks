# --------------------------------------------------------------------------------
# 1. Common Project Variables
# --------------------------------------------------------------------------------

variable "project_name" {
  type        = string
  description = "Short project name used as the prefix for AWS resource names and tags."
}

variable "region" {
  type        = string
  description = "AWS region where the infrastructure is deployed."

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "The region must be a valid AWS region identifier, for example ap-south-1 or us-east-1."
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags to be applied to all resources."
}

# --------------------------------------------------------------------------------
# 2. VPC Variables
# --------------------------------------------------------------------------------

variable "vpc_id" {
  type        = string
  description = "VPC ID where the security groups are created."
}