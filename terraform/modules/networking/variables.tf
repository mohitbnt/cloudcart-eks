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

variable "data_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the isolated data subnets (RDS, ElastiCache). One per AZ, at least two."

  validation {
    condition     = length(var.data_subnet_cidrs) >= 2
    error_message = "Provide at least two data_subnet_cidrs (RDS and ElastiCache subnet groups need two AZs)."
  }

  validation {
    condition     = alltrue([for cidr in var.data_subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All data_subnet_cidrs values must be valid IPv4 CIDR blocks."
  }
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Toggle NAT Gateway provisioning. Enable for initial cluster bootstrapping or general internet access; disable if using VPC endpoints instead."
}

variable "enable_vpc_endpoints" {
  type        = bool
  default     = false
  description = "Toggle VPC endpoints for S3 and other AWS services. Enable to route traffic internally and save costs when a NAT Gateway is disabled."
}


variable "vpc_endpoint_sg_id" {
  type        = string
  description = "Security group ID used by the VPC interface endpoints."
}

# --------------------------------------------------------------------------------
# 3. IAM Role Configuration
# --------------------------------------------------------------------------------
variable "vpc_flow_logs_role_arn" {
  type        = string
  description = "ARN of the VPC Flow Logs role."
}