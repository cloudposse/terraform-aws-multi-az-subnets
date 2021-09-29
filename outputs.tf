output "az_subnet_ids" {
  value       = { for az, m in local.output_map : az => m.subnet_id }
  description = "Map of AZ names to subnet IDs"
}

output "az_subnet_arns" {
  value       = { for az, m in local.output_map : az => m.subnet_arn }
  description = "Map of AZ names to subnet ARNs"
}

output "az_subnet_cidr_blocks" {
  value       = { for az, m in local.output_map : az => m.subnet_cidr_block }
  description = "Map of AZ names to subnet CIDR blocks"
}

output "az_subnet_ipv6_cidr_blocks" {
  value       = { for az, m in local.output_map : az => m.subnet_ipv6_cidr_block }
  description = "Map of AZ names to subnet IPv6 CIDR blocks"
}

output "az_route_table_ids" {
  value       = { for az, m in local.output_map : az => m.route_table_id }
  description = " Map of AZ names to Route Table IDs"
}

output "az_ngw_ids" {
  # No ellipsis needed since this module makes either public or private subnets. See the TF 0.15 one function
  value       = { for az, m in local.output_map : az => m.ngw_id }
  description = "Map of AZ names to NAT Gateway IDs (only for public subnets)"
}

output "az_subnet_map" {
  value       = local.output_map
  description = "Map of AZ names to map of information about subnets"
}
