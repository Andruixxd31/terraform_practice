# REST API Gateway
resource "aws_api_gateway_rest_api" "poc-api" {
  name = "poc-api-gateway"
  description = "Proxy to handle requests to our API"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# api gateway authorizer
resource "aws_api_gateway_authorizer" "poc-authorizer" {
  name                   = "poc-authorizer"
  rest_api_id            = aws_api_gateway_rest_api.poc-api.id
  authorizer_uri         = aws_lambda_function.poc-authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.poc-invocation_role.arn
}

# Invocation Role
resource "aws_iam_role" "poc-invocation_role" {
  name = "poc-api_gateway_auth_invocation"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Role Policy
resource "aws_iam_role_policy" "poc-invocation_policy" {
  name = "poc-default"
  role = aws_iam_role.poc-invocation_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "lambda:InvokeFunction",
      "Effect": "Allow",
      "Resource": "${aws_lambda_function.poc-authorizer.arn}"
    }
  ]
}
EOF
}

# Lambda Role
resource "aws_iam_role" "poc-lambda" {
  name = "poc-demo-lambda"
  path = "/"

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


# Lambda Authorizer
resource "aws_lambda_function" "poc-authorizer" {
  filename      = "lambda-function.zip"
  function_name = "poc-api_gateway_authorizer"
  role          = aws_iam_role.poc-lambda.arn
  handler       = "handler.handler"
  runtime       = "nodejs14.x"
  package_type  = "Zip"
  source_code_hash = filebase64sha256("lambda-function.zip")
}

### Endpoint of get data

# Resource
resource "aws_api_gateway_resource" "get-data" {
  rest_api_id = aws_api_gateway_rest_api.poc-api.id
  parent_id   = aws_api_gateway_rest_api.poc-api.root_resource_id
  path_part   = "get-data"
}

# Method
resource "aws_api_gateway_method" "get-data-method" {
  rest_api_id   = aws_api_gateway_rest_api.poc-api.id
  resource_id   = aws_api_gateway_resource.get-data.id
  http_method   = "GET"
  authorization = "NONE"
}

### Endpoint of upload data

# Resource
resource "aws_api_gateway_resource" "upload-data" {
  rest_api_id = aws_api_gateway_rest_api.poc-api.id
  parent_id   = aws_api_gateway_rest_api.poc-api.root_resource_id
  path_part   = "upload-data"
}

resource "aws_api_gateway_method" "upload-data-method" {
  rest_api_id   = aws_api_gateway_rest_api.poc-api.id
  resource_id   = aws_api_gateway_resource.upload-data.id
  http_method   = "POST"
  authorization = "NONE"
}
