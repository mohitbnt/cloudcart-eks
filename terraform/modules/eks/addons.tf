# --------------------------------------------------------------------------------
# 1. VPC CNI Addon
# --------------------------------------------------------------------------------
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main_eks_cluster.name
  addon_name   = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main_eks_cluster
  ]
}

# --------------------------------------------------------------------------------
# 2. COREDNS Addon
# --------------------------------------------------------------------------------
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main_eks_cluster.name
  addon_name   = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main_eks_cluster,
    aws_eks_node_group.main_eks_node_group
  ]
}

# --------------------------------------------------------------------------------
# 3. Kube Proxy Addon
# --------------------------------------------------------------------------------
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main_eks_cluster.name
  addon_name   = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main_eks_cluster,
    aws_eks_node_group.main_eks_node_group
  ]
}

# --------------------------------------------------------------------------------
# 4. Pod Identity Agent Addon
# --------------------------------------------------------------------------------
resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.main_eks_cluster.name
  addon_name   = "eks-pod-identity-agent"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main_eks_cluster,
    aws_eks_node_group.main_eks_node_group
  ]
}

# --------------------------------------------------------------------------------
# 5. EBS CSI Driver Addon & Pod Identity Association
# --------------------------------------------------------------------------------
resource "aws_eks_pod_identity_association" "ebs_csi_association" {
  cluster_name    = aws_eks_cluster.main_eks_cluster.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = var.ebs_csi_role_arn

  depends_on = [
    aws_eks_addon.pod_identity_agent
  ]
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name = aws_eks_cluster.main_eks_cluster.name
  addon_name   = "aws-ebs-csi-driver"

  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_cluster.main_eks_cluster,
    aws_eks_node_group.main_eks_node_group,
    aws_eks_pod_identity_association.ebs_csi_association
  ]
}

# -----------------------------------------------------------------------------
# 6. EKS Pod Identity Association for ESO ServiceAccount
# -----------------------------------------------------------------------------
resource "aws_eks_pod_identity_association" "eso_pod_identity" {
  cluster_name    = aws_eks_cluster.main_eks_cluster.name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = var.eso_role_arn

  depends_on = [ 
    aws_eks_cluster.main_eks_cluster,
    aws_eks_addon.pod_identity_agent
   ]
}