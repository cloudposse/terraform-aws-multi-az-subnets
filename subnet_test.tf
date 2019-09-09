locals {
  test_count       = var.enabled == "true" && var.type == "test" ? length(var.availability_zones) : 0
  test_route_count = var.enabled == "true" && var.type == "test" ? var.az_ngw_count : 0
}

module "test_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  attributes = compact(concat(var.attributes, ["test"]))
  enabled    = var.enabled
}

resource "aws_subnet" "test" {
  count             = local.test_count
  vpc_id            = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)

  tags = merge(
    module.test_label.tags,
    {
      "Name" = "${module.test_label.id}${var.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(var.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

resource "aws_network_acl" "test" {
  count      = var.enabled == "true" && var.type == "test" && signum(length(var.test_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.test.*.id
  dynamic "egress" {
    for_each = var.private_network_acl_egress
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # testuced a comprehensive set here. Consider simplifying
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
    for_each = var.private_network_acl_ingress
    content {
      # TF-UPGRADE-TODO: The automatic upgrade tool can't predict
      # which keys might be set in maps assigned here, so it has
      # testuced a comprehensive set here. Consider simplifying
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
  tags       = module.test_label.tags
  depends_on = [aws_subnet.test]
}

resource "aws_route_table" "test" {
  count  = local.test_count
  vpc_id = var.vpc_id

  tags = merge(
    module.test_label.tags,
    {
      "Name" = "${module.test_label.id}${var.delimiter}${element(var.availability_zones, count.index)}"
      "AZ"   = element(var.availability_zones, count.index)
      "Type" = var.type
    },
  )
}

resource "aws_route_table_association" "test" {
  count          = local.test_count
  subnet_id      = element(aws_subnet.test.*.id, count.index)
  route_table_id = element(aws_route_table.test.*.id, count.index)
  depends_on = [
    aws_subnet.test,
    aws_route_table.test,
  ]
}

resource "aws_route" "test_default" {
  count = local.test_route_count
  route_table_id = zipmap(
    var.availability_zones,
    matchkeys(
      aws_route_table.test.*.id,
      aws_route_table.test.*.tags.AZ,
      var.availability_zones,
    ),
  )[element(keys(var.az_ngw_ids), count.index)]
  nat_gateway_id         = var.az_ngw_ids[element(keys(var.az_ngw_ids), count.index)]
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.test]
}