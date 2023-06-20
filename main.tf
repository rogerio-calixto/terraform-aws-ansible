
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

data "template_file" "user_data_manager" {
  template = file("scripts/ansible_clients.sh")
  # vars = {
  #   environment = var.environment
  # }
}
module "ec2-manager" {
  user_data         = data.template_file.user_data_manager.rendered
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

data "template_file" "user_data_client" {
  template = file("scripts/ansible_client.sh")
  # vars = {
  #   environment = var.environment
  # }
}
module "ec2-client" {
  source            = "../terraform-aws-ec2"
  user_data         = data.template_file.user_data_client.rendered
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