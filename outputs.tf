output "az_subnet_ids" {
  value = "${zipmap(var.availability_zones, matchkeys(coalescelist(aws_subnet.private.*.id, aws_subnet.public.*.id), coalescelist(aws_subnet.private.*.tags.AZ, aws_subnet.public.*.tags.AZ), var.availability_zones))}"
}

output "az_route_table_ids" {
  value = "${zipmap(var.availability_zones, matchkeys(coalescelist(aws_route_table.private.*.id, aws_route_table.public.*.id), coalescelist(aws_route_table.private.*.tags.AZ, aws_route_table.public.*.tags.AZ), var.availability_zones))}"
}

output "az_ngw_ids" {
  value = "${zipmap(var.availability_zones, matchkeys(aws_nat_gateway.public.*.id, aws_nat_gateway.public.*.tags.AZ, var.availability_zones))}"
}
