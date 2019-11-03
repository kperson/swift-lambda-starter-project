---
to: Build/api_authorizer.tf
unless_exists: true
sh: cd Build && terraform fmt
---
data "aws_region" "api_authorizer_current" {}
resource "aws_api_gateway_authorizer" "api_authorizer" {
  name                             = format("%s_<%=locals.api%>_api_authorizer", var.namespace)
  type                             = "REQUEST"
  rest_api_id                      = aws_api_gateway_rest_api.<%=locals.api%>.id
  identity_source                  = "method.request.header.X-Forwarded-For"
  authorizer_result_ttl_in_seconds = 0
  authorizer_uri                   = format("arn:aws:apigateway:%s:lambda:path/2015-03-31/functions/%s/invocations", <%=locals.lambda_arn%>)
  authorizer_credentials           = data.template_file.authorizer_role_arn.rendered
}