variable "public_subnet_az" { default = "us-east-1a" }
variable "allowed_ingress_ip" { default = "0.0.0.0/0" }
variable "ami_name" { default = "al2023-ami-2023.5.20240624.0-kernel-6.1-x86_64" }
variable "instance_type" { default = "t3.micro" }