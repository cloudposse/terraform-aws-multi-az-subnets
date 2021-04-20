locals {
  private_count       = local.private_enabled ? length(var.availability_zones) : 0
  private_route_count = length(var.az_ngw_ids)
}

module "private_label" {
  source  = "cloudposse/label/null"
  version = "0.22.1"

  attributes = compact(concat(var.attributes, ["private"]))

  context = module.this.context
}

resource "aws_subnet" "private" {
  count = local.private_count

  vpc_id            = var.vpc_id
  availability_zone = local.availability_zones[count.index]
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)

  tags = merge(
    module.private_label.tags,
    {
      "Name" = "${module.private_label.id}${module.this.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = local.availability_zones[count.index]
      "Type" = var.type
    },
  )
}

resource "aws_network_acl" "private" {
  count = local.private_enabled && var.private_network_acl_id == "" ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.private.*.id
  dynamic "egress" {
    for_each = var.private_network_acl_egress
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
    for_each = var.private_network_acl_ingress
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
  tags       = module.private_label.tags
  depends_on = [aws_subnet.private]
}

resource "aws_route_table" "private" {
  count = local.private_count

  vpc_id = var.vpc_id

  tags = merge(
    module.private_label.tags,
    {
      "Name" = "${module.private_label.id}${module.this.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(local.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

resource "aws_route_table_association" "private" {
  count = local.private_count

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  depends_on = [
    aws_subnet.private,
    aws_route_table.private,
  ]
}

resource "aws_route" "default" {
  count = local.private_route_count

  route_table_id = zipmap(
    local.availability_zones,
    matchkeys(
      aws_route_table.private.*.id,
      aws_route_table.private.*.tags.AZ,
      local.availability_zones,
    ),
  )[element(keys(var.az_ngw_ids), count.index)]
  nat_gateway_id         = var.az_ngw_ids[element(keys(var.az_ngw_ids), count.index)]
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private]
}

locals {
  private_az_subnets = tolist([for subnet in aws_subnet.private[*] : {
    availability_zone = subnet.tags.AZ
    subnet            = subnet
    subnet_id         = subnet.id
    subnet_arn        = subnet.arn
  }])
  private_az_route_table_ids = tolist([for route_table in aws_route_table.private[*] : {
    availability_zone = route_table.tags.AZ
    route_table       = route_table
    route_table_id    = route_table.id
  }])
  # NAT gateways not present in private subnets
  private_az_ngw_ids = tolist([])
}