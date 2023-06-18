resource "aws_ec2_transit_gateway_peering_attachment" "client_global_services" {
  peer_account_id         = data.aws_caller_identity.global_services.account_id
  peer_region             = data.aws_region.global_services.name
  peer_transit_gateway_id = aws_ec2_transit_gateway.global_services.id

  transit_gateway_id = aws_ec2_transit_gateway.client.id

  tags = merge(local.tags, {
    Name = "client_global_services_peering_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "client_global_services" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.client_global_services.id

  tags = merge(local.tags, {
    Name = "client_global_services_peering_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_ec2_transit_gateway_route" "client_global_services" {
  destination_cidr_block         = var.global_services_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.client_global_services.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.client.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.client_global_services]

  provider = aws.client
}

resource "aws_ec2_transit_gateway_route" "global_services_to_client" {
  destination_cidr_block         = var.client_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.client_global_services.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.global_services.association_default_route_table_id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.client_global_services]

  provider = aws.global_services
}
