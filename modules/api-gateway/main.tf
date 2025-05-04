resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = "API Gateway for Courses and Authors"
}

# Resources
resource "aws_api_gateway_resource" "proxy" {
  for_each = toset(var.endpoints)

  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.value
}

locals {
  http_methods = {
    "get-all-authors" = "GET"
    "get-all-courses" = "GET"
    "get-course"      = "GET"
    "save-course"     = "POST"
    "update-course"   = "PUT"
    "delete-course"   = "DELETE"
  }

  cors_headers = {
    "Access-Control-Allow-Origin"  = "'http://${var.website_endpoint},https://${var.website_endpoint}'"
    "Access-Control-Allow-Methods" = "'GET,POST,PUT,DELETE,OPTIONS'"
    "Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key'"
  }
}

# Methods and Integrations
resource "aws_api_gateway_method" "proxy" {
  for_each = aws_api_gateway_resource.proxy

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = each.value.id
  http_method   = local.http_methods[split("/", each.key)[0]]
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  for_each = aws_api_gateway_method.proxy

  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = each.value.resource_id
  http_method             = each.value.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_uri_map[split("/", each.key)[0]]
}

# CORS Configuration
resource "aws_api_gateway_method" "options" {
  for_each = aws_api_gateway_resource.proxy

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = each.value.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  for_each = aws_api_gateway_method.options

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "options" {
  for_each = aws_api_gateway_method.options

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  status_code = "200"

  response_parameters = {
    for key in keys(local.cors_headers) :
    "method.response.header.${key}" => true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "options" {
  for_each = aws_api_gateway_method.options

  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = each.value.resource_id
  http_method = each.value.http_method
  status_code = aws_api_gateway_method_response.options[each.key].status_code

  response_parameters = {
    for key, value in local.cors_headers :
    "method.response.header.${key}" => value
  }
}

# Lambda Permissions
resource "aws_lambda_permission" "lambda_permission" {
  for_each = var.lambda_function_arns

  statement_id  = "AllowAPIGatewayInvoke_${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

# Deployment and Stage
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.proxy,
      aws_api_gateway_method.proxy,
      aws_api_gateway_integration.lambda,
      aws_api_gateway_method.options,
      aws_api_gateway_integration.options,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda,
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options,
  ]
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.stage_name
}

# Get current region
data "aws_region" "current" {} 