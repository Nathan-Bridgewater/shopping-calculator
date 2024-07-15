resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_security_group" "security_group" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol = "icmp"
  cidr_ipv4 = var.allowed_ingress_ip
  from_port = -1
  to_port = -1
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = var.allowed_ingress_ip
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_ipv4 = var.allowed_ingress_ip
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol = "tcp"
  from_port = 8080
  to_port = 8080
  cidr_ipv4 = var.allowed_ingress_ip
}

resource "aws_vpc_security_group_egress_rule" "allow_http" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol = "tcp"
  from_port = 8080
  to_port = 8080
  cidr_ipv4 = var.allowed_ingress_ip
}

resource "aws_vpc_security_group_egress_rule" "allow_https" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_ipv4 = var.allowed_ingress_ip
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  } 
}

resource "aws_route_table_association" "association_a" {
  route_table_id = aws_route_table.route_table.id
  subnet_id = aws_subnet.public_subnet.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = var.public_subnet_az
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "flask-app"
  image_tag_mutability = "MUTABLE"
}