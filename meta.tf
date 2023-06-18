locals {
  tags = {
    Project       = var.project_name
    TFE_Workspace = var.tfe_workspace
  }
}

resource "random_id" "suffix" {
  byte_length = 4
}

data "aws_caller_identity" "default" {}
data "aws_region" "default" {}
data "aws_caller_identity" "global_services" {
  provider = aws.global_services
}
data "aws_region" "global_services" {
  provider = aws.global_services
}
data "aws_caller_identity" "client" {
  provider = aws.client
}
data "aws_region" "client" {
  provider = aws.client
}

data "aws_route53_resolver_endpoint" "global_services_inbound" {
  resolver_endpoint_id = aws_route53_resolver_endpoint.global_services_inbound.id

  provider = aws.global_services
}
