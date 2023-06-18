resource "aws_route53_zone" "global_services" {
  name    = "gs.tl.internal"
  comment = "Global services DNS"

  vpc {
    vpc_id = aws_vpc.global_services.id
  }

  tags = merge(local.tags, {
    Name = "global_services_private_dns_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_route53_record" "global_services_instance" {
  zone_id = aws_route53_zone.global_services.zone_id
  name    = "gs.tl.internal"
  type    = "A"
  ttl     = 300
  records = [aws_instance.global_services.private_ip]

  provider = aws.global_services
}

resource "aws_route53_zone" "client" {
  name    = "client.tl.internal"
  comment = "Client DNS"

  vpc {
    vpc_id = aws_vpc.global_services.id
  }

  tags = merge(local.tags, {
    Name = "client_private_dns_${random_id.suffix.hex}"
  })

  provider = aws.global_services
}

resource "aws_route53_record" "client_instance" {
  zone_id = aws_route53_zone.client.zone_id
  name    = "client.tl.internal"
  type    = "A"
  ttl     = 300
  records = [aws_instance.client.private_ip]

  provider = aws.global_services
}
