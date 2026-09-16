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

# --------------------------------------------------------------------------------
# 5. Network Configuration
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

# --------------------------------------------------------------------------------
# 6. EKS Cluster and Node Group variables
# --------------------------------------------------------------------------------

variable "kubernetes_version" {
  type        = string
  description = "EKS cluster version."
  default     = "1.36"
}

variable "office_ips" {
  type        = list(string)
  description = "CIDR blocks allowed to access the public EKS Kubernetes API endpoint."
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes in the EKS node group."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes in the EKS node group."
  default     = 3
}

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes in the EKS node group."
  default     = 2
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types used by the EKS node group."
}

variable "disk_size" {
  type        = number
  description = "Disk size in GB used by the EKS node group."
  default     = 20
}

variable "capacity_type" {
  type        = string
  description = "Capacity type used by the EKS node group."
  default     = "SPOT"
}