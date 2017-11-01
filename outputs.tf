output "ngw_ids" {
  value       = "${aws_nat_gateway.public.*.id}"
  description = "NAT Gateway IDs"
}

output "ngw_private_ips" {
  value       = "${aws_nat_gateway.public.*.private_ip}"
  description = "Private IP addresses of the NAT Gateways"
}

output "ngw_public_ips" {
  value       = "${aws_nat_gateway.public.*.public_ip}"
  description = "Public IP addresses of the NAT Gateways"
}

output "subnet_ids" {
  value       = ["${coalescelist(aws_subnet.private.*.id, aws_subnet.public.*.id)}"]
  description = "Subnet IDs"
}

output "route_table_ids" {
  value       = ["${coalescelist(aws_route_table.public.*.id, aws_route_table.private.*.id)}"]
  description = "Route Table IDs"
}

output "az_subnet_ids" {
  value = "${zipmap(var.availability_zones, matchkeys(coalescelist(aws_subnet.private.*.id, aws_subnet.public.*.id), coalescelist(aws_subnet.private.*.tags.AZ, aws_subnet.public.*.tags.AZ), var.availability_zones))}"
}
