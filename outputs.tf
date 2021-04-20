output "az_subnet_ids" {
  # No ellipsis needed since this module makes either public or private subnets. See the TF 0.15 one function
  value = {
    for subnet_tuple in concat(local.public_az_subnets, local.private_az_subnets) : subnet_tuple.availability_zone => subnet_tuple.subnet_id
  }
  description = "Map of AZ names to subnet IDs"
}

output "az_route_table_ids" {
  # No ellipsis needed since this module makes either public or private subnets. See the TF 0.15 one function
  value = {
    for route_table_tuple in concat(local.public_az_route_table_ids, local.private_az_route_table_ids) : route_table_tuple.availability_zone => route_table_tuple.route_table_id
  }
  description = " Map of AZ names to Route Table IDs"
}

output "az_ngw_ids" {
  # No ellipsis needed since this module makes either public or private subnets. See the TF 0.15 one function
  value = {
    for nat_gw_tuple in concat(local.public_az_ngw_ids, local.private_az_ngw_ids) : nat_gw_tuple.availability_zone => nat_gw_tuple.nat_gateway_id
  }
  description = "Map of AZ names to NAT Gateway IDs (only for public subnets)"
}

output "az_subnet_arns" {
  # No ellipsis needed since this module makes either public or private subnets. See the TF 0.15 one function
  value = {
    for subnet_tuple in concat(local.public_az_subnets, local.private_az_subnets) : subnet_tuple.availability_zone => subnet_tuple.subnet_arn
  }
  description = "Map of AZ names to subnet ARNs"
}

