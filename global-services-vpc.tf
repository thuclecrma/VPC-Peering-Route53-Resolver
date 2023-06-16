resource "aws_vpc" "global_services" {
  cidr_block           = var.global_services_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, {
    Name = "global_services_vpc_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_subnet" "global_services_private_a" {
  vpc_id            = aws_vpc.global_services.id
  cidr_block        = var.global_services_private_subnet_a_cidr
  availability_zone = "us-east-1a"

  tags = merge(local.tags, {
    Name = "global_services_private_a_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_subnet" "global_services_private_b" {
  vpc_id            = aws_vpc.global_services.id
  cidr_block        = var.global_services_private_subnet_b_cidr
  availability_zone = "us-east-1b"

  tags = merge(local.tags, {
    Name = "global_services_private_b_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_route_table" "global_services" {
  vpc_id = aws_vpc.global_services.id

  tags = merge(local.tags, {
    Name = "global_services_route_table_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_main_route_table_association" "global_services" {
  vpc_id         = aws_vpc.global_services.id
  route_table_id = aws_route_table.global_services.id

  provider = aws.global_services
}

resource "aws_route" "global_services_vpc_tgw" {
  route_table_id         = aws_route_table.global_services.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_ec2_transit_gateway.global_services.id

  provider = aws.global_services
}
