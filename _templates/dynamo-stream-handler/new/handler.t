---
inject: true
to: Build/events.tf
after: //Auto-generated Events
skip_if: module "dynamo_stream_<%=locals.table%>_handler" {
sh: cd Build && terraform fmt
---
module "dynamo_stream_<%=locals.table%>_handler" {
  source         = "github.com/kperson/swift-lambda-tools//terraform/dynamo-stream-lambda"
  build_params   = local.build_params
  runtime_layers = [var.swift_layer]
  env            = local.env
  function_name  = format("%s_<%=locals.handler.replace(/\./g, '_')%>", var.namespace)
  handler        = "<%=locals.handler%>"
  stream_arn     = module.dynamo_<%=locals.table%>.stream_arn
}
