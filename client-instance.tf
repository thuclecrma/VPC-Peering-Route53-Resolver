resource "aws_security_group" "client_instance" {
  name        = "client_instance_sg_${random_id.suffix.hex}"
  description = "Allow ICMP (ping)"
  vpc_id      = aws_vpc.client.id

  ingress {
    description = "ICMP from global network"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.global_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.tags, {
    Name = "client_instance_sg_${random_id.suffix.hex}"
  })

  provider = aws.client
}

resource "aws_instance" "client" {
  ami                  = "ami-07dfed28fcf95241c"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  subnet_id              = aws_subnet.client_private_a.id
  vpc_security_group_ids = [aws_security_group.client_instance.id]

  tags = merge(local.tags, {
    Name = "client_instance_${random_id.suffix.hex}"
  })

  provider = aws.client
}
