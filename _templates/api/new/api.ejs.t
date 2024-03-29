---
to: Build/resource_api_<%=locals.api%>.tf
unless_exists: true
sh: cd Build && terraform fmt
---
resource "aws_api_gateway_rest_api" "<%=locals.api%>" {
  name = format("%s_<%=locals.api%>", var.namespace)

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
