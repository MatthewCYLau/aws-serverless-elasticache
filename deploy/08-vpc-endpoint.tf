resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.app.id
  service_name = "com.amazonaws.us-east-1.dynamodb"
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.public.id
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
}