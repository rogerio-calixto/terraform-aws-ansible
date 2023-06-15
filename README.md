# terraform-aws-ansible
Creates instances with management by ansible

# Instruction:

Set the variables below according to your needs:

- project
- region
- ami
- instance-type
- keypair-name
- subnet_counts
- instance-name
- authorized-ssh-ip - list(string)-> [ For security don´t set it as default. Instead inform on terraform plan command ]

## Example:

- project           -> "tf-ansible"
- region            -> "us-east-1"
- ami               -> "ami-0715c1897453cabd1"
- instance-type     -> "t3.micro"
- keypair-name      -> "devops-keypair"
- subnet_counts     -> 3
- instance-name     -> "devops-portfolio-instance"
- authorized-ssh-ip -> ["123.456.789.100/32"]

# outputs

Some key fields about infrastructure created will be returned:

- vpc-id
- private-avaiable_zones
- private-subnet-ids [] -> list(string)
- public-subnet-ids [] -> list(string)
- manager-ip
- manager-sg-id
- client-ips
- client-sg-id

# TF commands

## Plan
terraform plan -out="tfplan.out"
## Apply
terraform apply "tfplan.out"
## Destroy
terraform destroy -auto-approve