output "private_az_subnet_ids" {
  value = "${module.private_subnets.az_subnet_ids}"
}

output "public_az_subnet_ids" {
  value = "${module.public_subnets.az_subnet_ids}"
}

output "private_az_ngw_ids" {
  value = "${module.private_subnets.az_ngw_ids}"
}

output "public_az_ngw_ids" {
  value = "${module.public_subnets.az_ngw_ids}"
}

output "private_az_route_table_ids" {
  value = "${module.private_subnets.az_route_table_ids}"
}

output "public_az_route_table_ids" {
  value = "${module.public_subnets.az_route_table_ids}"
}
