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

output "manager-ip" {
  value = module.ec2-manager.ec2_public_ips
}

output "manager-sg-id" {
  value = module.ec2-manager.sg-id
}

# output "client-ips" {
#   value = module.ec2-client.ec2_public_ips
# }

# output "client-sg-id" {
#   value = module.ec2-client.sg-id
# }