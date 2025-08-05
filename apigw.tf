resource "aws_api_gateway_rest_api" "api_gw" {
  name        = "view-counter"
  description = "API Gateway for view counter"
}

resource "aws_api_gateway_resource" "counter" {
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
  parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
  path_part   = "views"
}

resource "aws_api_gateway_method" "get_counter" {
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  resource_id   = aws_api_gateway_resource.counter.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api_gw.id
  resource_id             = aws_api_gateway_resource.counter.id
  http_method             = aws_api_gateway_method.get_counter.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.increment_view_counter.invoke_arn
}

resource "aws_api_gateway_deployment" "api_gw_deployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.api_gw.id
}

resource "aws_api_gateway_stage" "api_gw_stage" {
  rest_api_id   = aws_api_gateway_rest_api.api_gw.id
  deployment_id = aws_api_gateway_deployment.api_gw_deployment.id
  stage_name    = "counter"
}

# Lambda permissions
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.increment_view_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gw.execution_arn}/*/*"
}

output "api_url" {
  value       = "${aws_api_gateway_stage.api_gw_stage.invoke_url}/views"
  description = "The URL of the API Gateway endpoint"
}
