resource "aws_elasticache_replication_group" "redis" {
  automatic_failover_enabled    = false
  availability_zones            = ["us-east-1a"]
  replication_group_id          = "serverless-api-redis"
  replication_group_description = "Serverless API Redis"
  node_type                     = "cache.t2.micro"
  number_cache_clusters         = 1
  parameter_group_name          = "default.redis6.x"
  engine_version                = "6.x"
  port                          = 6379
  subnet_group_name             = "elasticachetestgroup"
  security_group_ids            = ["sg-03b6fb6842a1688ce"]
}