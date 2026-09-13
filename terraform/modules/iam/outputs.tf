# --------------------------------------------------------------------------------
# 1. Publish EKS Cluster Role ARN
# --------------------------------------------------------------------------------
output "eks_cluster_role_arn" {
  value       = aws_iam_role.eks_cluster_role.arn
  description = "ARN of the EKS cluster role."
}

# --------------------------------------------------------------------------------
# 2. Publish EKS Worker Role ARN
# --------------------------------------------------------------------------------
output "eks_worker_role_arn" {
  value       = aws_iam_role.eks_worker_role.arn
  description = "ARN of the EKS worker role."
}

# --------------------------------------------------------------------------------
# 3. Publish EBS CSI Role ARN
# --------------------------------------------------------------------------------
output "ebs_csi_role_arn" {
  value       = aws_iam_role.ebs_csi_role.arn
  description = "ARN of the EBS CSI role."
}

# --------------------------------------------------------------------------------
# 4. Public ESO Role ARN
# --------------------------------------------------------------------------------
output "eso_role_arn" {
  value       = aws_iam_role.eso_role.arn
  description = "ARN of the External Secrets Operator role."
}

# --------------------------------------------------------------------------------
# 5. Publish LB Controller Role ARN
# --------------------------------------------------------------------------------
output "lb_controller_role_arn" {
  value       = aws_iam_role.lb_controller_role.arn
  description = "ARN of the AWS Load Balancer Controller role."
}