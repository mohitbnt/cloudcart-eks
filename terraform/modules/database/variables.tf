# --------------------------------------------------------------------------------
# 1. Common Project Variables
# --------------------------------------------------------------------------------

variable "project_name" {
  type        = string
  description = "Short project name used as the prefix for AWS resource names and tags."
}

variable "environment" {
  type        = string
  description = "Deployment environment for the application."

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "The environment variable must be exactly 'dev' or 'prod'."
  }
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
# 2. Network Variables
# --------------------------------------------------------------------------------

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs used by the RDS subnet group."
}

variable "rds_sg_id" {
  type        = string
  description = "Security group ID attached to the RDS instance."
}

# =============================================================================
# Database variables
# =============================================================================

variable "db_instance_config" {
  type = object({
    allocated_storage     = number
    family                = string
    engine                = string
    engine_version        = string
    instance_class        = string
    db_name               = string
    username              = string
    multi_az              = bool
    backup_retention      = number
    deletion_protection   = bool
    skip_final_snapshot   = bool
  })

  description = "Configuration for the Amazon RDS PostgreSQL database instance."
}
