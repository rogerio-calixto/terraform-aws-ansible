
provider "aws" {
  region  = var.region
  profile = local.aws_profile
}

module "main-network" {
  source        = "../terraform-aws-network"
  project       = var.project
  region        = var.region
  subnet_counts = var.subnet_counts
}

module "ec2-manager" {
  source            = "../terraform-aws-ec2"
  project           = var.project
  region            = var.region
  ami               = var.ami
  instance-type     = var.instance-type
  instance-name     = "${var.instance-name}-ansible-manager"
  keypair-name      = var.keypair-name
  authorized-ssh-ip = ["${var.authorized-ssh-ip}/32"]
  vpc-id            = module.main-network.vpc-id
  subnet-ids        = module.main-network.public-subnet-ids
}

module "ec2-client" {
  source            = "../terraform-aws-ec2"
  servers           = 3
  region            = var.region
  ami               = var.ami
  instance-type     = var.instance-type
  instance-name     = "${var.instance-name}-ansible_client"
  keypair-name      = var.keypair-name
  authorized-ssh-ip = ["${var.authorized-ssh-ip}/32", "${module.ec2-manager.ec2_private_ips[0]}/32"]
  vpc-id            = module.main-network.vpc-id
  subnet-ids        = module.main-network.public-subnet-ids
}