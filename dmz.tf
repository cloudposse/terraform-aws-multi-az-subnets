locals {
  dmz_count              = var.enabled == "true" && var.type == "dmz" ? length(var.availability_zones) : 0
  dmz_nat_gateways_count = var.enabled == "true" && var.type == "dmz" && var.nat_gateway_enabled == "true" ? length(var.availability_zones) : 0
}

module "dmz_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  attributes = compact(concat(var.attributes, ["dmz"]))
  enabled    = var.enabled
}

resource "aws_subnet" "dmz" {
  count             = local.dmz_count
  vpc_id            = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)

  tags = merge(
    module.dmz_label.tags,
    {
      "Name" = "${module.dmz_label.id}${var.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(var.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

resource "aws_network_acl" "dmz" {
  count      = var.enabled == "true" && var.type == "dmz" && signum(length(var.dmz_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.dmz.*.id
  dynamic "egress" {
    for_each = var.dmz_network_acl_egress
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

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
    for_each = var.dmz_network_acl_ingress
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # produced a comprehensive set here. Consider simplifying
      # this after confirming which keys can be set in practice.

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
  tags       = module.dmz_label.tags
  depends_on = [aws_subnet.dmz]
}

resource "aws_route_table" "dmz" {
  count  = local.dmz_count
  vpc_id = var.vpc_id

  tags = merge(
    module.dmz_label.tags,
    {
      "Name" = "${module.dmz_label.id}${var.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(var.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

resource "aws_route" "dmz" {
  count                  = local.dmz_count
  route_table_id         = element(aws_route_table.dmz.*.id, count.index)
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.dmz]
}

resource "aws_route_table_association" "dmz" {
  count          = local.dmz_count
  subnet_id      = element(aws_subnet.dmz.*.id, count.index)
  route_table_id = element(aws_route_table.dmz.*.id, count.index)
  depends_on = [
    aws_subnet.dmz,
    aws_route_table.dmz,
  ]
}

resource "aws_eip" "dmz" {
  count = local.dmz_nat_gateways_count
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "dmz" {
  count         = local.dmz_nat_gateways_count
  allocation_id = element(aws_eip.dmz.*.id, count.index)
  subnet_id     = element(aws_subnet.dmz.*.id, count.index)
  depends_on    = [aws_subnet.dmz]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    module.dmz_label.tags,
    {
      "Name" = "${module.dmz_label.id}${var.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(var.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

# Dummy list of NAT Gateway IDs to use in the outputs for private subnets and when `nat_gateway_enabled=false` for dmz subnets
# Needed due to Terraform limitation of not allowing using conditionals with maps and lists
locals {
  dmz_dummy_az_ngw_ids = slice(
    [
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
      "0",
    ],
    0,
    length(var.availability_zones),
  )
}
