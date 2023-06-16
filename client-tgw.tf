resource "aws_ec2_transit_gateway" "client" {
  description = "Client transit gateway"

  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "disable"
  default_route_table_association = "enable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "disable"

  tags = merge(local.tags, {
    Name = "client_tgw_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_ec2_transit_gateway_vpc_attachment" "client_vpc" {
  subnet_ids         = [aws_subnet.client_private_a.id, aws_subnet.client_private_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.client.id
  vpc_id             = aws_vpc.client.id

  tags = merge(local.tags, {
    Name = "client_tgw_to_vpc_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_ec2_transit_gateway_route_table_propagation" "client_vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.client_vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.client.association_default_route_table_id

  provider = aws.client
}
