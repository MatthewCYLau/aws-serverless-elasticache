resource "aws_lambda_permission" "todos" {
  statement_id  = "AllowExecutionFromAPIGatewayUCI"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_todos.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.app.execution_arn}/*"
}
