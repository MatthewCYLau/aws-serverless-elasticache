data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "elasticache-redis-subnet-group"
  description = "Serverless API Redis subnet group"
  subnet_ids = data.aws_subnet_ids.default.ids
}