locals {
  enabled = module.this.enabled

  public_enabled     = local.enabled && var.type == "public"
  private_enabled    = local.enabled && var.type == "private"
  availability_zones = local.enabled ? var.availability_zones : []

  output_map = { for az in(local.enabled ? var.availability_zones : []) : az => {
    subnet_id         = local.public_enabled ? aws_subnet.public[az].id : aws_subnet.private[az].id
    subnet_arn        = local.public_enabled ? aws_subnet.public[az].arn : aws_subnet.private[az].arn
    subnet_cidr_block = local.public_enabled ? aws_subnet.public[az].cidr_block : aws_subnet.private[az].cidr_block
    route_table_id    = local.public_enabled ? aws_route_table.public[az].id : aws_route_table.private[az].id
    ngw_id            = local.public_enabled && var.nat_gateway_enabled ? aws_nat_gateway.public[az].id : null

    subnet_ipv6_cidr_block = local.public_ipv6_enabled ? aws_subnet.public[az].ipv6_cidr_block : null
    }
  }
}
