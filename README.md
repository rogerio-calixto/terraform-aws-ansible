# terraform-aws-ansible
Creates instances (manager and clients) for experimentation using ansible

# Instruction:

Set the variables below according to your needs:

- project
- region
- ami
- instance-type
- keypair-name
- subnet_counts
- instance-name
- authorized-ssh-ip - list(string) -> 
     [ For security don´t set it as default. Instead inform on terraform plan command ]

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
- manager-public-ips [] -> list(string)
- manager-private-ips [] -> list(string)
- manager-sg-id
- client-public-ips [] -> list(string)
- client-private-ips [] -> list(string)
- client-sg-id

# TF commands

## Plan
terraform plan -out="tfplan.out"
## Apply
terraform apply "tfplan.out"
## Destroy
terraform destroy -auto-approve

# How to test:

After about 10 minutes infrastructure to be created:
   - connect on the manager machine via ssh,
   - go to the projects folder typing: cd /ansible-projects
   - set inventory file, set the client´s local ips you want to manage in "app" session

After this just need to execute the ansible-script.sh file typing: bash ansible-script.sh

This command will install nginx and configure a simple website in the clients machine configured
and you wil be able to access them through their public ips