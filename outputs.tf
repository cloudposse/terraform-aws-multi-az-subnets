output "az_subnet_ids" {
  value       = "${zipmap(var.availability_zones, matchkeys(coalescelist(aws_subnet.private.*.id, aws_subnet.public.*.id), coalescelist(aws_subnet.private.*.tags.AZ, aws_subnet.public.*.tags.AZ), var.availability_zones))}"
  description = "Map of AZ names to subnet IDs"
}

output "az_route_table_ids" {
  value       = "${zipmap(var.availability_zones, matchkeys(coalescelist(aws_route_table.private.*.id, aws_route_table.public.*.id), coalescelist(aws_route_table.private.*.tags.AZ, aws_route_table.public.*.tags.AZ), var.availability_zones))}"
  description = " Map of AZ names to Route Table IDs"
}

output "az_ngw_ids" {
  value       = "${zipmap(var.availability_zones, coalescelist(matchkeys(aws_nat_gateway.public.*.id, aws_nat_gateway.public.*.tags.AZ, var.availability_zones), local.dummy_az_ngw_ids))}"
  description = "Map of AZ names to NAT Gateway IDs (only for public subnets)"
}
