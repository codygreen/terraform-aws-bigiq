# BIG-IQ Management Public IP Addresses
output "mgmt_public_ips" {
  description = "List of BIG-IP public IP addresses for the management interfaces"
  value       = aws_eip.mgmt[*].public_ip
}

# BIG-IQ Management Public DNS
output "mgmt_public_dns" {
  description = "List of BIG-IP public DNS records for the management interfaces"
  value       = aws_eip.mgmt[*].public_dns
}

# BIG-IQ Management Port
output "mgmt_port" {
  description = "HTTPS Port used for the BIG-IP management interface"
  value       = "443"
}

# Public Network Interface
output "public_nic_ids" {
  description = "List of BIG-IP public network interface ids"
  value       = aws_network_interface.mgmt[*].id
}
