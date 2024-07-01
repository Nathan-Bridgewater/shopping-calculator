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
  cidr_ipv4 = "0.0.0.0/0"
  from_port = -1
  to_port = -1
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol = "tcp"
  from_port = 22
  to_port = 22
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls" {
  security_group_id = aws_security_group.security_group.id
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
  cidr_ipv4 = "0.0.0.0/0"
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
  availability_zone = "us-east-1a"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.5.20240624.0-kernel-6.1-x86_64"]
  }
}

data "local_file" "public_ssh_key" {
  filename = "../../../my-ssh-key.pub"
}
resource "aws_key_pair" "web_server_key_pair" {
  key_name = "web-server-key"
  public_key = data.local_file.public_ssh_key.content 
}

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.web_server_key_pair.key_name
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups = [ aws_security_group.security_group.id ]
}
