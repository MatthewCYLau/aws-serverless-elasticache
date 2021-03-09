resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = data.aws_vpc.default.id
  service_name = "com.amazonaws.us-east-1.dynamodb"
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = "rtb-ce9098b1"
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
}