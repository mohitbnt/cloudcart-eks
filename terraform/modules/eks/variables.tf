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
# 2. EKS Cluster and Node Group Variables
# --------------------------------------------------------------------------------

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs where the EKS cluster is deployed."
}

variable "eks_cluster_role_arn" {
  type        = string
  description = "ARN of the EKS cluster role."
}

variable "eks_cluster_sg_id" {
  type        = string
  description = "Security group ID used by the EKS cluster."
}

variable "kubernetes_version" {
  type        = string
  description = "EKS cluster version."
  default     = "1.36"
}

variable "office_ips" {
  type        = list(string)
  description = "CIDR blocks allowed to access the public EKS Kubernetes API endpoint."
}


variable "eks_worker_role_arn" {
  type        = string
  description = "ARN of the EKS worker role."
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

variable "eks_worker_sg_id" {
  type        = string
  description = "Security group ID used by the EKS worker nodes."
}

# --------------------------------------------------------------------------------
# 3. EBS CSI Variables
# --------------------------------------------------------------------------------

variable "ebs_csi_role_arn" {
  type        = string
  description = "ARN of the EBS CSI role."
}

# --------------------------------------------------------------------------------
# 4. ESO Variables
# --------------------------------------------------------------------------------
variable "eso_role_arn" {
  type        = string
  description = "ARN of the External Secrets Operator role."
}

# --------------------------------------------------------------------------------
# 5. LB Controller Variables
# --------------------------------------------------------------------------------

variable "lb_controller_role_arn" {
  type        = string
  description = "ARN of the AWS Load Balancer Controller role."
}