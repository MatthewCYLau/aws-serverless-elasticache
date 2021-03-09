data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# resource "aws_vpc" "vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
#   tags = {
#     Name = "Node Express ECS VPC"
#   }
# }

# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id = aws_vpc.vpc.id
# }

# resource "aws_subnet" "pub_subnet" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.0.0/24"
#   availability_zone = "us-east-1b"

# }
# resource "aws_subnet" "pub_subnet2" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.internet_gateway.id
#   }
# }

# resource "aws_route_table_association" "route_table_association" {
#   subnet_id      = aws_subnet.pub_subnet.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table_association" "route_table_association2" {
#   subnet_id      = aws_subnet.pub_subnet2.id
#   route_table_id = aws_route_table.public.id
# }

resource "aws_elasticache_subnet_group" "redis" {
  name        = "elasticache-redis-subnet-group"
  description = "Serverless API Redis subnet group"
  subnet_ids  = data.aws_subnet_ids.default.ids
}

resource "aws_security_group" "redis" {
  name        = "redis-sg"
  vpc_id      = data.aws_vpc.default.id
  description = "controls access to ElastiCache Redis cluster"

  ingress {
    protocol  = "tcp"
    from_port = 6379
    to_port   = 6379
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}