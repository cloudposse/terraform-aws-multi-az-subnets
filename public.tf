locals {
  public_azs              = local.public_enabled ? { for idx, az in var.availability_zones : az => idx } : {}
  public_nat_gateway_azs  = local.public_enabled && var.nat_gateway_enabled ? local.public_azs : {}
  public_ipv6_enabled     = local.public_enabled && var.ipv6_enabled
  public_ipv6_azs         = local.public_ipv6_enabled ? local.public_azs : {}
  public_ipv6_target_mask = 64
}

module "public_label" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  attributes = ["public"]

  context = module.this.context
}

resource "aws_subnet" "public" {
  for_each = local.public_azs

  vpc_id            = var.vpc_id
  availability_zone = each.key
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), each.value)
  ipv6_cidr_block = local.public_ipv6_enabled ? cidrsubnet(var.ipv6_cidr_block, (
    local.public_ipv6_target_mask - tonumber(split("/", var.ipv6_cidr_block)[1])
  ), each.value) : null

  tags = merge(
    module.public_label.tags,
    {
      "Name" = "${module.public_label.id}${module.this.delimiter}${each.key}"
      "Type" = var.type
    },
  )
}

resource "aws_network_acl" "public" {
  count = local.public_enabled && var.public_network_acl_id == "" ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = values(aws_subnet.public)[*].id

  dynamic "egress" {
    for_each = var.public_network_acl_egress
    content {
      action          = lookup(egress.value, "action", null)
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = lookup(egress.value, "from_port", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = lookup(egress.value, "protocol", null)
      rule_no         = lookup(egress.value, "rule_no", null)
      to_port         = lookup(egress.value, "to_port", null)
    }
  }
  dynamic "ingress" {
    for_each = var.public_network_acl_ingress
    content {
      action          = lookup(ingress.value, "action", null)
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = lookup(ingress.value, "protocol", null)
      rule_no         = lookup(ingress.value, "rule_no", null)
      to_port         = lookup(ingress.value, "to_port", null)
    }
  }
  tags       = module.public_label.tags
  depends_on = [aws_subnet.public]
}

resource "aws_route_table" "public" {
  for_each = local.public_azs
  vpc_id   = var.vpc_id

  tags = merge(
    module.public_label.tags,
    {
      "Name" = "${module.public_label.id}${module.this.delimiter}${each.key}"
      "Type" = var.type
    },
  )
}

resource "aws_route" "public" {
  for_each = local.public_azs

  route_table_id         = aws_route_table.public[each.key].id
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.public]
}

resource "aws_route" "public_ipv6" {
  for_each = local.public_ipv6_azs

  route_table_id              = aws_route_table.public[each.key].id
  gateway_id                  = var.igw_id
  destination_ipv6_cidr_block = "::/0"
  depends_on                  = [aws_route_table.public]
}

resource "aws_route_table_association" "public" {
  for_each = local.public_azs

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
  depends_on = [
    aws_subnet.public,
    aws_route_table.public,
  ]
}

resource "aws_eip" "public" {
  for_each = local.public_nat_gateway_azs
  domain   = "vpc"
  tags     = module.public_label.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "public" {
  for_each = local.public_nat_gateway_azs

  allocation_id = aws_eip.public[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  depends_on    = [aws_subnet.public]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    module.public_label.tags,
    {
      "Name" = "${module.public_label.id}${module.this.delimiter}${each.key}"
      "Type" = var.type
    },
  )
}
