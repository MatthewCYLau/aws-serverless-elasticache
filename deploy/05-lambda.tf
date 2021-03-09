resource "aws_lambda_function" "process_todos" {
  function_name = "ProcessTodos"

  s3_bucket = "aws-serverless-elasticache-lambdas"
  s3_key    = "v1.0.0/processTodos.zip"
  handler   = "index.handler"
  runtime   = "nodejs10.x"

  role = aws_iam_role.process_todos_lambda.arn

  environment {
    variables = {
      REDIS_HOST_URL = aws_elasticache_replication_group.redis.primary_endpoint_address
    }
  }

  vpc_config {
    subnet_ids         = data.aws_subnet_ids.default.ids
    security_group_ids = ["sg-03b6fb6842a1688ce"]
  }

  depends_on = [
    aws_elasticache_replication_group.redis
  ]
}

resource "aws_iam_role" "process_todos_lambda" {
  name               = "${var.app_name}-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "process_todos_attach" {
  role       = aws_iam_role.process_todos_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "prcoess-queue-lambda-policy"
  role = aws_iam_role.process_todos_lambda.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "SpecificTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGet*",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:Get*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWrite*",
                "dynamodb:CreateTable",
                "dynamodb:Delete*",
                "dynamodb:Update*",
                "dynamodb:PutItem"
            ],
            "Resource": [
              "${aws_dynamodb_table.todos.arn}*"
            ]
        }
    ]
}
EOF
}