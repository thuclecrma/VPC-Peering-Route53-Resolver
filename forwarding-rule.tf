resource "aws_route53_resolver_rule" "client" {
  domain_name          = "tl.internal"
  name                 = "client_fwd_rule"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.client_outbound.id

  dynamic "target_ip" {
    for_each = data.aws_route53_resolver_endpoint.global_services_inbound.ip_addresses

    content {
      ip = target_ip.value
    }
  }

  tags = merge(local.tags, {
    Name = "client_fwd_rule_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_route53_resolver_rule_association" "client_fwd_rule" {
  resolver_rule_id = aws_route53_resolver_rule.client.id
  vpc_id           = aws_vpc.client.id

  provider = aws.client
}
