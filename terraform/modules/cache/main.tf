
# --------------------------------------------------------------------------------
# 1. Create Subnet Group for Redis Elasticache
# --------------------------------------------------------------------------------
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.project_name}-${var.environment}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-redis-subnet-group"
    }
  )
}

# --------------------------------------------------------------------------------
# 2. Create parameter group for Redis Elasticache
# --------------------------------------------------------------------------------
resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name        = "${var.project_name}-${var.environment}-redis-parameter-group"
  family      = "redis7"
  description = "Parameter group for Redis Elasticache for ${var.project_name} in ${var.environment}."

  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-redis-parameter-group"
    }
  )
}

# --------------------------------------------------------------------------------
# 3. Create Redis Elasticache Replication Group (Cluster)
# --------------------------------------------------------------------------------
resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id = "${var.project_name}-${var.environment}-redis-cluster"
  description          = "Redis Elasticache Cluster"

  engine             = "redis"
  engine_version     = var.cache_config.engine_version
  node_type          = var.cache_config.node_type
  port               = 6379
  subnet_group_name  = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids = [var.redis_sg_id]

  num_cache_clusters = 1

  parameter_group_name       = aws_elasticache_parameter_group.redis_parameter_group.name
  at_rest_encryption_enabled = true

  transit_encryption_enabled = false

  automatic_failover_enabled = var.cache_config.automatic_failover_enabled
  multi_az_enabled           = var.cache_config.multi_az_enabled

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-redis-cluster"
    }
  )
}
# --------------------------------------------------------------------------------
# 4. Create a secret to store the Redis Elasticache URL in Secrets Manager.
# --------------------------------------------------------------------------------
resource "aws_secretsmanager_secret" "redis_url" {
  name                    = "${var.project_name}/${var.environment}/redis-url"
  description             = "Redis URL for ${var.project_name} in ${var.environment}."
  recovery_window_in_days = 0
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-redis-url"
    }
  )
}

# --------------------------------------------------------------------------------
# 5. Create a secret version to store the Redis Elasticache URL in Secrets Manager.
# --------------------------------------------------------------------------------
resource "aws_secretsmanager_secret_version" "redis_url" {
  secret_id = aws_secretsmanager_secret.redis_url.id
  secret_string = jsonencode({
    REDIS_URL = "redis://${aws_elasticache_replication_group.redis_cluster.primary_endpoint_address}:6379/0"
  })
}