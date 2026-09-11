# --------------------------------------------------------------------------------
# 1. Database Module
# --------------------------------------------------------------------------------

module "database" {
  source = "../../modules/database"

  project_name = var.project_name
  environment  = var.environment
  region       = var.region
  common_tags = local.common_tags
  private_subnet_ids = data.terraform_remote_state.core_infra.outputs.private_subnet_ids
  rds_sg_id = data.terraform_remote_state.core_infra.outputs.rds_sg_id
  db_instance_config = var.db_instance_config
}

# --------------------------------------------------------------------------------
# 2. Cache Module
# --------------------------------------------------------------------------------

module "cache" {
  source = "../../modules/cache"

  project_name = var.project_name
  environment  = var.environment
  region       = var.region
  common_tags = local.common_tags
  private_subnet_ids = data.terraform_remote_state.core_infra.outputs.private_subnet_ids
  redis_sg_id = data.terraform_remote_state.core_infra.outputs.redis_sg_id
  cache_config = var.cache_config
}