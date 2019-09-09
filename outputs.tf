output "az_subnet_ids" {
  value = zipmap(
    var.availability_zones,
    coalescelist(aws_subnet.prod.*.id, aws_subnet.test.*.id, aws_subnet.stage.*.id, aws_subnet.dev.*.id, aws_subnet.dmz.*.id),
  )
  description = "Map of AZ names to subnet IDs"
}

output "az_route_table_ids" {
  value = zipmap(
    var.availability_zones,
    coalescelist(aws_route_table.prod.*.id, aws_route_table.test.*.id, aws_route_table.stage.*.id, aws_route_table.dev.*.id, aws_route_table.dmz.*.id),
  )
  description = " Map of AZ names to Route Table IDs"
}

output "az_ngw_ids" {
  value = zipmap(
    var.availability_zones,
    coalescelist(aws_nat_gateway.dmz.*.id, aws_nat_gateway.public.*.id, local.dummy_az_ngw_ids),
  )
  description = "Map of AZ names to NAT Gateway IDs (only for public subnets)"
}

output "az_subnet_arns" {
  value = zipmap(
    var.availability_zones,
    coalescelist(aws_subnet.prod.*.arn, aws_subnet.test.*.arn, aws_subnet.stage.*.arn, aws_subnet.dev.*.arn, aws_subnet.dmz.*.arn),
  )
  description = "Map of AZ names to subnet ARNs"
}
