resource "aws_elasticache_replication_group" "redis" {
  automatic_failover_enabled    = false
  availability_zones            = ["us-east-1a"]
  replication_group_id          = "serverless-api-redis"
  replication_group_description = "Serverless API Redis"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 1
  parameter_group_name          = "default.redis5.0"
  engine_version                = "5.0.6"
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.redis.name
  security_group_ids            = [aws_security_group.redis.id]
}