data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.ami_name]
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
  instance_type = var.instance_type
  key_name = aws_key_pair.web_server_key_pair.key_name
  subnet_id = var.instance_subnet_id
  associate_public_ip_address = true
  security_groups = [ var.security_group_id ]
}