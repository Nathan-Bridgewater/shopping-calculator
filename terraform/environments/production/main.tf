resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id
}

//resource "aws_route_table" "route_table" {
//  vpc_id = aws_vpc.main_vpc.vpc_id
//
//  route = 
//}

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

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.web_server_key_pair.key_name
  subnet_id = aws_subnet.public_subnet.id
  associate_public_ip_address = true
}

resource "aws_key_pair" "web_server_key_pair" {
  key_name = "web-server-key"
  public_key = data.local_file.public_ssh_key.content 
}