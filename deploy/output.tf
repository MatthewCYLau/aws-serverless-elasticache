output "api_base_url" {
  value = aws_api_gateway_deployment.app.invoke_url
}

output "redis_primary_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

