# --------------------------------------------------------------------------------
# Common Project Variables
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
# ECR Repository Variables
# --------------------------------------------------------------------------------

variable "repositories" {
  type        = list(string)
  description = "Service names; one repository <project_name>/<name> is created for each."
  default = [
    "frontend",
    "gateway",
    "identity",
    "catalog",
    "cart",
    "inventory",
    "order",
    "payment",
    "notification",
  ]
}

variable "image_tag_mutability" {
  type        = string
  description = "IMMUTABLE prevents overwriting a tag (recommended). Use MUTABLE only while experimenting."
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "max_image_count" {
  type        = number
  description = "Number of most recent images to keep per repository; older images expire."
  default     = 30
}

variable "force_delete" {
  type        = bool
  description = "Allow terraform destroy to delete repositories that still contain images."
  default     = false
}
