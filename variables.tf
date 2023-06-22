variable "project" {
  default = "tf-ansible"
}

variable "region" {
  default = "us-east-1"
}

variable "ami" {
  default = "ami-053b0d53c279acc90"
  #  "ami-0715c1897453cabd1"
}

variable "instance-type" {
  default = "t3.micro"
}

variable "keypair-name" {
  default = "devops-keypair"
}

variable "subnet_counts" {
  default = 3
}

variable "instance-name" {
  default = "portfolio"
}

variable "authorized-ssh-ip" {}

variable "s3-bucket-dest" {
  default = "s3://buck-devops/repository/ansible/manager-keygen/"
}

variable "email_keygen" {
  default = "rpc.devops@gmail.com"
}