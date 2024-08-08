module "core_platform" {
  source = "../../modules/core-platform"
  public_subnet_az = var.public_subnet_az
  allowed_ingress_ip = var.allowed_ingress_ip
}

module "flask_web_server" {
  source = "../../modules/flask-web-server"
  ami_name = var.ami_name
  instance_subnet_id = module.core_platform.public_subnet_id
  instance_type = var.instance_type
  security_group_id = module.core_platform.security_group_id
}

module "lambda_apigw" {
  source = "../../modules/lambda-apigw"
}