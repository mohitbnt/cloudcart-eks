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

  private_subnet_ids      = module.networking.private_subnet_ids
  eks_cluster_role_arn    = module.iam.eks_cluster_role_arn
  eks_worker_role_arn     = module.iam.eks_worker_role_arn
  eks_cluster_sg_id       = module.security.eks_cluster_sg_id
  kubernetes_version      = var.kubernetes_version
  office_ips              = var.office_ips
  eks_worker_sg_id        = module.security.eks_worker_sg_id
  min_size                = var.min_size
  max_size                = var.max_size
  desired_size            = var.desired_size
  instance_types          = var.instance_types
  disk_size               = var.disk_size
  capacity_type           = var.capacity_type
  ebs_csi_role_arn        = module.iam.ebs_csi_role_arn
  eso_role_arn            = module.iam.eso_role_arn
  lb_controller_role_arn  = module.iam.lb_controller_role_arn
  eks_admin_principal_arn = var.eks_admin_principal_arn

  depends_on = [
    module.networking,
    module.security,
    module.iam
  ]
}