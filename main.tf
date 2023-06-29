provider "aws" {
  region  = var.region
  profile = local.aws_profile
}