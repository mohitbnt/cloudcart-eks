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
# 2. Network Configuration
# --------------------------------------------------------------------------------

variable "vpc_cidr" {
  type        = string
  description = "IPv4 CIDR block for the VPC."

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the public subnets."

  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All public_subnet_cidrs values must be valid IPv4 CIDR blocks."
  }
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the private subnets."

  validation {
    condition     = alltrue([for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All private_subnet_cidrs values must be valid IPv4 CIDR blocks."
  }
}

variable "enable_nat_gateway" {
  type        = bool
  default     = false
  description = "Controls if a temporary NAT Gateway is provisioned. Keep false for private isolation; set true during initial setup/bootstrapping."
}

variable "vpc_endpoint_sg_id" {
  type        = string
  description = "Security group ID used by the VPC interface endpoints."
}