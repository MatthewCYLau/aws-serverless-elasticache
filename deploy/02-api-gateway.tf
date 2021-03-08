resource "aws_api_gateway_rest_api" "app" {
  name        = "${var.app_name}-api"
  description = "AWS Serverless ElastiCache API"
  body        = data.template_file.api_definition.rendered
}

data "template_file" "api_definition" {
  template = file("api/openapi.yaml")
  vars = {
    process_todos_lambda_invocation_arn = aws_lambda_function.process_todos.invoke_arn
  }
}

resource "aws_api_gateway_deployment" "app" {
  depends_on = [
    aws_api_gateway_rest_api.app
  ]
  rest_api_id = aws_api_gateway_rest_api.app.id
  stage_name  = var.environment
}