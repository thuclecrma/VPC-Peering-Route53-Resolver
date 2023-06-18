resource "aws_security_group" "global_services_dns" {
  name        = "global_services_dns_sg_${random_id.suffix.hex}"
  description = "Allow DNS"
  vpc_id      = aws_vpc.global_services.id

  ingress {
    description = "DNS from global"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.global_cidr]
  }

  ingress {
    description = "DNS from global"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = [var.global_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "global_services_dns_sg_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_route53_resolver_endpoint" "global_services_inbound" {
  name      = "global_services_inbound_endpoint"
  direction = "INBOUND"

  security_group_ids = [aws_security_group.global_services_dns.id]

  ip_address {
    subnet_id = aws_subnet.global_services_private_a.id
  }

  ip_address {
    subnet_id = aws_subnet.global_services_private_b.id
  }

  tags = merge(local.tags, {
    Name = "global_services_inbound_endpoint_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}
