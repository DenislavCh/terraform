provider "aws" {
  region = "eu-west-3"
}

module "my_vpc" {
  source      = "../terraform_modules/terraform-app/modules/vpc"
  vpc_cidr    = "192.168.0.0/16"
  tenancy     = "default"
  vpc_id      = "${module.my_vpc.vpc_id}"
  subnet_cidr = "192.168.1.0/24"
  
}

module "my_ec2" {
  source        = "../terraform_modules/terraform-app/modules/ec2"
  ec2_count     = 2
  ami_id        = "ami-00c08ad1a6ca8ca7c"
  instance_type = "t2.micro"
  subnet_id     = "${module.my_vpc.subnet_id}"
  security_group = "${module.my_vpc.security_group}"
  
}

