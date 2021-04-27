locals {
  enabled = module.this.enabled

  public_enabled      = local.enabled && var.type == "public"
  private_enabled     = local.enabled && var.type == "private"
  availability_zones  = local.enabled ? var.availability_zones : []
  nat_gateway_enabled = local.enabled && var.nat_gateway_enabled

  output_map = { for az in(local.enabled ? var.availability_zones : []) : az => {
    subnet_id      = local.public_enabled ? aws_subnet.public[az].id : aws_subnet.private[az].id
    subnet_arn     = local.public_enabled ? aws_subnet.public[az].arn : aws_subnet.private[az].arn
    route_table_id = local.public_enabled ? aws_route_table.public[az].id : aws_route_table.private[az].id
    }
  }
  # Only relevant for public subnets. Output is empty map for private subnets or when nat gateway is disabled
  output_ngw_id = { for az in(local.public_enabled && local.nat_gateway_enabled ? var.availability_zones : []) : az => {
    ngw_id         = local.public_enabled ? try(aws_nat_gateway.public[az].id, null) : null
    }
  }
}
