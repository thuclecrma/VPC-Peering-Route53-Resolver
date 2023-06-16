resource "aws_security_group" "global_services_ssm" {
  name        = "global_services_ssm_sg_${random_id.suffix.hex}"
  description = "Allow HTTPS"
  vpc_id      = aws_vpc.global_services.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.global_services_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "global_services_ssm_sg_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_vpc_endpoint" "global_services_ssm" {
  vpc_id            = aws_vpc.global_services.id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"
  ip_address_type   = "ipv4"
  subnet_ids        = [aws_subnet.global_services_private_a.id, aws_subnet.global_services_private_b.id]

  security_group_ids = [
    aws_security_group.global_services_ssm.id,
  ]

  private_dns_enabled = true

  tags = merge(local.tags, {
    Name = "global_services_ssm_endpoint_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_vpc_endpoint" "global_services_ssmmessages" {
  vpc_id            = aws_vpc.global_services.id
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  ip_address_type   = "ipv4"
  subnet_ids        = [aws_subnet.global_services_private_a.id, aws_subnet.global_services_private_b.id]

  security_group_ids = [
    aws_security_group.global_services_ssm.id,
  ]

  private_dns_enabled = true

  tags = merge(local.tags, {
    Name = "global_services_ssmmessages_endpoint_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}
