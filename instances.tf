data "template_file" "user_data_manager" {
  template = file("scripts/ansible_manager.sh")
  vars = {
    s3-bucket-dest = var.s3-bucket-dest
    s3-bucket-website = var.s3-bucket-website
    s3-bucket-portfolio-website = var.s3-bucket-portfolio-website
  }
}

module "ec2-manager" {
  user-data             = data.template_file.user_data_manager.rendered
  source                = "../terraform-aws-ec2"
  instance-profile-name = aws_iam_instance_profile.ec2-profile.name
  project               = var.project
  region                = var.region
  ami                   = var.ami
  instance-type         = var.instance-type
  instance-name         = "${var.instance-name}-ansible-manager"
  keypair-name          = var.keypair-name
  authorized-ssh-ip     = ["${var.authorized-ssh-ip}/32"]
  vpc-id                = module.main-network.vpc-id
  subnet-ids            = module.main-network.public-subnet-ids
}

data "template_file" "user_data_client" {
  template = file("scripts/ansible_client.sh")
  vars = {
    s3-bucket-dest = var.s3-bucket-dest
  }
}
module "ec2-client" {
  source                = "../terraform-aws-ec2"
  instance-profile-name = aws_iam_instance_profile.ec2-profile.name
  user-data             = data.template_file.user_data_client.rendered
  servers               = 3
  region                = var.region
  ami                   = var.ami
  instance-type         = var.instance-type
  instance-name         = "${var.instance-name}-ansible_client"
  keypair-name          = var.keypair-name
  authorized-ssh-ip     = ["${var.authorized-ssh-ip}/32", "${module.ec2-manager.ec2_private_ips[0]}/32"]
  vpc-id                = module.main-network.vpc-id
  subnet-ids            = module.main-network.public-subnet-ids
}