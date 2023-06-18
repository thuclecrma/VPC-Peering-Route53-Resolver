resource "aws_security_group" "client_dns" {
  name        = "client_dns_sg_${random_id.suffix.hex}"
  description = "Allow DNS"
  vpc_id      = aws_vpc.client.id

  ingress {
    description = "DNS from client VPC"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.client_vpc_cidr]
  }

  ingress {
    description = "DNS from global"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.client_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "client_dns_sg_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_route53_resolver_endpoint" "client_outbound" {
  name      = "client_inbound_endpoint"
  direction = "OUTBOUND"

  security_group_ids = [aws_security_group.client_dns.id]

  ip_address {
    subnet_id = aws_subnet.client_private_a.id
  }

  ip_address {
    subnet_id = aws_subnet.client_private_b.id
  }

  tags = merge(local.tags, {
    Name = "client_outbound_endpoint_${random_id.suffix.hex}"
  })

  provider = aws.client
}
