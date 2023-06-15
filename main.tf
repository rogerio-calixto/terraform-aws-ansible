
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
  subnet-id         = module.main-network.public-subnet-ids[0]
}

module "ec2-client-01" {
  source            = "../terraform-aws-ec2"
  region            = var.region
  ami               = var.ami
  instance-type     = var.instance-type
  instance-name     = "${var.instance-name}-ansible_client-01"
  keypair-name      = var.keypair-name
  authorized-ssh-ip = ["${var.authorized-ssh-ip}/32", "${module.ec2-manager.ec2_public_ip}/32"]
  vpc-id            = module.main-network.vpc-id
  subnet-id         = module.main-network.public-subnet-ids[0]
}

module "ec2-client-02" {
  source            = "../terraform-aws-ec2"
  region            = var.region
  ami               = var.ami
  instance-type     = var.instance-type
  instance-name     = "${var.instance-name}-ansible_client-02"
  keypair-name      = var.keypair-name
  authorized-ssh-ip = ["${var.authorized-ssh-ip}/32", "${module.ec2-manager.ec2_public_ip}/32"]
  vpc-id            = module.main-network.vpc-id
  subnet-id         = module.main-network.public-subnet-ids[1]
}