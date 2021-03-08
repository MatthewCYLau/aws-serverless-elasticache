resource "aws_dynamodb_table" "todos" {
  name             = "todos"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "todoId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "todoId"
    type = "S"
  }
}