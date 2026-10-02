# Use the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group
resource "aws_security_group" "demo_sg" {
  name        = "demo-ec2-sg"
  description = "Allow SSH and HTTP inbound, all outbound"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name        = "demo-ec2-sg"
    Environment = "dev"
  }
}

# Allow SSH
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.demo_sg.id
  description       = "Allow SSH"
  cidr_ipv4         = var.allowed_ssh_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Allow HTTP
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.demo_sg.id
  description       = "Allow HTTP"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "all_out" {
  security_group_id = aws_security_group.demo_sg.id
  description       = "Allow all outbound traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# EC2 Instance
resource "aws_instance" "demo" {
  ami                         = "ami-0d27e0fb3bac4d724"
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.demo_sg.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = "demo-master"
    Environment = "dev"
  }
}
