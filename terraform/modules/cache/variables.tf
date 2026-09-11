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
# 2. Network Configuration
# --------------------------------------------------------------------------------
variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs used by the Redis subnet group."
}

variable "redis_sg_id" {
  type        = string
  description = "Security group ID attached to the Redis cluster."
}

# --------------------------------------------------------------------------------
# 3. Cache Configuration
# --------------------------------------------------------------------------------

variable "cache_config" {
  type = object({
    engine_version             = string
    node_type                  = string
    automatic_failover_enabled = bool
    multi_az_enabled           = bool
  })

  description = "Configuration for the ElastiCache Redis cluster."
}
