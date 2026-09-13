# --------------------------------------------------------------------------------
# 1. Networking Module
# --------------------------------------------------------------------------------

module "networking" {
  source = "../modules/networking"

  project_name = var.project_name
  region       = var.region
  common_tags  = local.common_tags

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  vpc_endpoint_sg_id   = module.security.vpc_endpoint_sg_id
  enable_nat_gateway   = var.enable_nat_gateway
}

# --------------------------------------------------------------------------------
# 2. Security Module
# --------------------------------------------------------------------------------

module "security" {
  source = "../modules/security"

  project_name = var.project_name
  region       = var.region
  common_tags  = local.common_tags
  vpc_id       = module.networking.vpc_id
}

# --------------------------------------------------------------------------------
# 3. IAM Module
# --------------------------------------------------------------------------------

module "iam" {
  source = "../modules/iam"

  project_name = var.project_name
  region       = var.region
  common_tags  = local.common_tags
}

# --------------------------------------------------------------------------------
# 4. EKS Module
# --------------------------------------------------------------------------------

module "eks" {
  source = "../modules/eks/"

  project_name = var.project_name
  region       = var.region
  common_tags  = local.common_tags

  private_subnet_ids     = module.networking.private_subnet_ids
  eks_cluster_role_arn   = module.iam.eks_cluster_role_arn
  eks_worker_role_arn    = module.iam.eks_worker_role_arn
  eks_cluster_sg_id      = module.security.eks_cluster_sg_id
  kubernetes_version     = var.kubernetes_version
  public_access_cidr     = var.public_access_cidr
  eks_worker_sg_id       = module.security.eks_worker_sg_id
  min_size               = var.min_size
  max_size               = var.max_size
  desired_size           = var.desired_size
  instance_types         = var.instance_types
  disk_size              = var.disk_size
  capacity_type          = var.capacity_type
  ebs_csi_role_arn       = module.iam.ebs_csi_role_arn
  eso_role_arn           = module.iam.eso_role_arn
  lb_controller_role_arn = module.iam.lb_controller_role_arn

  depends_on = [
    module.networking,
    module.security,
    module.iam
  ]
}

# --------------------------------------------------------------------------------
# 5. Install External Secrets Operator via Helm
# --------------------------------------------------------------------------------
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  version          = "0.14.2" # Note: Swapped to a verified valid Helm version (usually 0.x.x for ESO)
  namespace        = "external-secrets"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    module.eks,
    module.iam
  ]
}
# --------------------------------------------------------------------------------
# 6. Install your Custom Secret Store Manifests
# --------------------------------------------------------------------------------
resource "helm_release" "eso_config" {
  name      = "eso-config"
  chart     = "${path.module}/eso-config"
  namespace = "external-secrets"

  # Pass variables into your manifest template
  values = [
    yamlencode({
      storeName = "aws-secrets-backend"
      awsRegion = var.region
    })
  ]

  depends_on = [
    helm_release.external_secrets
  ]
}

# -----------------------------------------------------------------------------
# 7. Deploy the AWS Load Balancer Controller via Helm
# -----------------------------------------------------------------------------
resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.16.0"

  values = [
    yamlencode({
      clusterName = module.eks.cluster_name
      region      = var.region
      vpcId       = module.networking.vpc_id

      # Disable features requiring public AWS endpoints not supported by VPC Endpoints
      enableShield = false
      enableWaf    = false
      enableWafv2  = false

      # Configure the ServiceAccount to match your Pod Identity association
      serviceAccount = {
        create      = true
        name        = "aws-load-balancer-controller"
        annotations = {}
      }
      replicaCount = 2
    })
  ]

  depends_on = [
    module.eks,
    module.iam
  ]
}
