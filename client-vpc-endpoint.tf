resource "aws_security_group" "client_ssm" {
  name        = "client_ssm_sg_${random_id.suffix.hex}"
  description = "Allow HTTPS"
  vpc_id      = aws_vpc.client.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.client_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "client_ssm_sg_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_vpc_endpoint" "client_ssm" {
  vpc_id            = aws_vpc.client.id
  service_name      = "com.amazonaws.us-west-2.ssm"
  vpc_endpoint_type = "Interface"
  ip_address_type   = "ipv4"
  subnet_ids        = [aws_subnet.client_private_a.id, aws_subnet.client_private_b.id]

  security_group_ids = [
    aws_security_group.client_ssm.id,
  ]

  private_dns_enabled = true

  tags = merge(local.tags, {
    Name = "client_ssm_endpoint_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_vpc_endpoint" "client_ssmmessages" {
  vpc_id            = aws_vpc.client.id
  service_name      = "com.amazonaws.us-west-2.ssmmessages"
  vpc_endpoint_type = "Interface"
  ip_address_type   = "ipv4"
  subnet_ids        = [aws_subnet.client_private_a.id, aws_subnet.client_private_b.id]

  security_group_ids = [
    aws_security_group.client_ssm.id,
  ]

  private_dns_enabled = true

  tags = merge(local.tags, {
    Name = "client_ssmmessages_endpoint_${random_id.suffix.hex}"
  })

  provider = aws.client
}
