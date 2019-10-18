# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

# BIG-IP Management Public IP Addresses
output "bigiq_mgmt_ips" {
  value = module.bigiq.mgmt_public_ips
}

# BIG-IP Management Public DNS Address
output "bigiq_mgmt_dns" {
  value = module.bigiq.mgmt_public_dns
}

# BIG-IP Management Port
output "bigiq_mgmt_port" {
  value = module.bigiq.mgmt_port
}
# BIG-IP Password
output "password" {
  value     = random_password.password
  sensitive = true
}

# BIG-IP Password Secret name
output "aws_secretmanager_secret_name" {
  value = aws_secretsmanager_secret.bigiq.name
}
