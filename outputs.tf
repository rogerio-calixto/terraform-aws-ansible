output "vpc-id" {
  value = module.main-network.vpc-id
}

output "private-avaiable_zones" {
  value = module.main-network.avaiable_zones
}

output "private-subnet-ids" {
  value = module.main-network.private-subnet-ids
}

output "public-subnet-ids" {
  value = module.main-network.public-subnet-ids
}

output "manager-instance-ip" {
  value = module.ec2-manager.ec2_public_ips
}

output "manager-sg-id" {
  value = module.ec2-manager.sg-id
}

# output "client_01-ip" {
#   value = module.ec2-client-01.ec2_public_ip
# }

# output "client-01-sg-id" {
#   value = module.ec2-client-01.sg-id
# }

# output "client_02-ip" {
#   value = module.ec2-client-02.ec2_public_ip
# }

# output "client-02-sg-id" {
#   value = module.ec2-client-02.sg-id
# }

output "client-ips" {
  value = module.ec2-client.ec2_public_ips
}

output "client-sg-id" {
  value = module.ec2-client.sg-id
}
