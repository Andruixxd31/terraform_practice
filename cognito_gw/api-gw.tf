
# REST API Gateway
resource "aws_api_gateway_rest_api" "cog-id-api" {
  name = "cog-id-api"
  description = "Proxy to handle requests to our API"
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

### Endpoint of Transactions

# Resource
resource "aws_api_gateway_resource" "transactions-resource" {
  rest_api_id = aws_api_gateway_rest_api.cog-id-api.id
  parent_id   = aws_api_gateway_rest_api.cog-id-api.root_resource_id
  path_part   = "transaction"
}

# GET Method
resource "aws_api_gateway_method" "transactions-method-get" {
  rest_api_id   = aws_api_gateway_rest_api.cog-id-api.id
  resource_id   = aws_api_gateway_resource.transactions-resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# POST Method
resource "aws_api_gateway_method" "transactions-method-post" {
  rest_api_id   = aws_api_gateway_rest_api.cog-id-api.id
  resource_id   = aws_api_gateway_resource.transactions-resource.id
  http_method   = "POST"
  authorization = "NONE"
}


### Endpoint of Bookings

# Resource
resource "aws_api_gateway_resource" "bookings-resource" {
  rest_api_id = aws_api_gateway_rest_api.cog-id-api.id
  parent_id   = aws_api_gateway_rest_api.cog-id-api.root_resource_id
  path_part   = "bookings"
}

# POST Method
resource "aws_api_gateway_method" "bookings-method-post" {
  rest_api_id   = aws_api_gateway_rest_api.cog-id-api.id
  resource_id   = aws_api_gateway_resource.bookings-resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# Get Method
resource "aws_api_gateway_method" "bookings-method-get" {
  rest_api_id   = aws_api_gateway_rest_api.cog-id-api.id
  resource_id   = aws_api_gateway_resource.bookings-resource.id
  http_method   = "POST"
  authorization = "NONE"
}

## Endpoint of Admin Bookings
resource "aws_api_gateway_resource" "admin-booking-resource" {
  rest_api_id = aws_api_gateway_rest_api.cog-id-api.id
  parent_id   = aws_api_gateway_resource.bookings-resource.id
  path_part   = "admin"
}

# GET Method
resource "aws_api_gateway_method" "admin-bookings-method-get" {
  rest_api_id   = aws_api_gateway_rest_api.cog-id-api.id
  resource_id   = aws_api_gateway_resource.admin-booking-resource.id
  http_method   = "GET"
  authorization = "NONE"
}

## Deployment

/*
## Test Stage
resource "aws_api_gateway_stage" "test-stage" {
  deployment_id = aws_api_gateway_deployment.cog-id-api.id
  rest_api_id   = aws_api_gateway_rest_api.cog-id-api.id
  stage_name    = "example"
}
*/
