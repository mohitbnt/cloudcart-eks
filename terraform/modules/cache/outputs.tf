# Publish Redis URL
output "redis_endpoint" {
  description = "Redis endpoint"
  value       = aws_elasticache_replication_group.redis_cluster.primary_endpoint_address
}