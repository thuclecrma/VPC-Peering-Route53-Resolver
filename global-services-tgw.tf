resource "aws_ec2_transit_gateway" "global_services" {
  description = "Global services transit gateway"

  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "enable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "disable"

  tags = merge(local.tags, {
    Name = "global_services_tgw_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_ec2_transit_gateway_vpc_attachment" "global_services_vpc" {
  subnet_ids         = [aws_subnet.global_services_private_a.id, aws_subnet.global_services_private_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.global_services.id
  vpc_id             = aws_vpc.global_services.id

  tags = merge(local.tags, {
    Name = "global_services_tgw_to_vpc_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_ec2_transit_gateway_route_table_propagation" "global_services_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.global_services_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.global_services.association_default_route_table_id

  provider = aws.global_services
}
