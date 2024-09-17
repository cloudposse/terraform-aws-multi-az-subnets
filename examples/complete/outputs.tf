output "private_az_subnet_ids" {
  description = "Map of AZ names to private subnet IDs"
  value       = module.private_subnets.az_subnet_ids
}

output "public_az_subnet_ids" {
  description = "Map of AZ names to public subnet IDs"
  value       = module.public_subnets.az_subnet_ids
}

output "private_az_subnet_arns" {
  description = "Map of AZ names to private subnet ARNs"
  value       = module.private_subnets.az_subnet_arns
}

output "public_az_subnet_arns" {
  description = "Map of AZ names to public subnet ARNs"
  value       = module.public_subnets.az_subnet_arns
}

output "public_az_ngw_ids" {
  description = "Map of AZ names to NAT Gateway IDs (only for public subnets)"
  value       = module.public_subnets.az_ngw_ids
}

output "private_az_route_table_ids" {
  description = " Map of AZ names to private Route Table IDs"
  value       = module.private_subnets.az_route_table_ids
}

output "public_az_route_table_ids" {
  description = " Map of AZ names to public Route Table IDs"
  value       = module.public_subnets.az_route_table_ids
}

output "private_az_subnet_cidr_blocks" {
  description = "Map of AZ names to private subnet CIDR blocks"
  value       = module.private_subnets.az_subnet_cidr_blocks
}

output "public_az_subnet_cidr_blocks" {
  description = "Map of AZ names to public subnet CIDR blocks"
  value       = module.public_subnets.az_subnet_cidr_blocks
}

output "public_az_subnet_ipv6_cidr_blocks" {
  description = "Map of AZ names to public subnet IPv6 CIDR blocks"
  value       = module.public_subnets.az_subnet_ipv6_cidr_blocks
}
