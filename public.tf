locals {
  public_count              = local.public_enabled ? length(var.availability_zones) : 0
  public_nat_gateways_count = local.public_enabled && var.nat_gateway_enabled ? length(var.availability_zones) : 0
}

module "public_label" {
  source  = "cloudposse/label/null"
  version = "0.22.1"

  attributes = compact(concat(var.attributes, ["public"]))

  context = module.this.context
}

resource "aws_subnet" "public" {
  count = local.public_count

  vpc_id            = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)

  tags = merge(
    module.public_label.tags,
    {
      "Name" = "${module.public_label.id}${module.this.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(var.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

resource "aws_network_acl" "public" {
  count = local.public_enabled && var.public_network_acl_id == "" ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.public.*.id
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
  count  = local.public_count
  vpc_id = var.vpc_id

  tags = merge(
    module.public_label.tags,
    {
      "Name" = "${module.public_label.id}${module.this.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(var.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

resource "aws_route" "public" {
  count                  = local.public_count
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.public]
}

resource "aws_route_table_association" "public" {
  count          = local.public_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  depends_on = [
    aws_subnet.public,
    aws_route_table.public,
  ]
}

resource "aws_eip" "public" {
  count = local.public_nat_gateways_count
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "public" {
  count         = local.public_nat_gateways_count
  allocation_id = element(aws_eip.public.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_subnet.public]

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    module.public_label.tags,
    {
      "Name" = "${module.public_label.id}${module.this.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(var.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

# Dummy list of NAT Gateway IDs to use in the outputs for private subnets and when `nat_gateway_enabled=false` for public subnets
# Needed due to Terraform limitation of not allowing using conditionals with maps and lists
locals {
  dummy_az_ngw_ids = slice(
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

