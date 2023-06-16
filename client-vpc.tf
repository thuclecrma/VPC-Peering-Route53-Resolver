resource "aws_vpc" "client" {
  cidr_block           = var.client_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, {
    Name = "client_vpc_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_subnet" "client_private_a" {
  vpc_id            = aws_vpc.client.id
  cidr_block        = var.client_private_subnet_a_cidr
  availability_zone = "us-west-2a"

  tags = merge(local.tags, {
    Name = "client_private_a_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_subnet" "client_private_b" {
  vpc_id            = aws_vpc.client.id
  cidr_block        = var.client_private_subnet_b_cidr
  availability_zone = "us-west-2b"

  tags = merge(local.tags, {
    Name = "client_private_b_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_route_table" "client" {
  vpc_id = aws_vpc.client.id

  tags = merge(local.tags, {
    Name = "client_route_table_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_main_route_table_association" "client" {
  vpc_id         = aws_vpc.client.id
  route_table_id = aws_route_table.client.id

  provider = aws.client
}

resource "aws_route" "client_vpc_tgw" {
  route_table_id         = aws_route_table.client.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_ec2_transit_gateway.client.id

  provider = aws.client
}
