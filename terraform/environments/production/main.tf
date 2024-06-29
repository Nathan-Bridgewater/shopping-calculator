resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["al2023-ami-2023.4.20240611.0-kernel-6.1-arm64"]
  }
}

resource "aws_instance" "web_server" {
  ami = data.aws_ami.amazon_linux
  instance_type = "t3.micro"
}

# resource "aws_key_pair" "web_server_key_pair" {
  
# }