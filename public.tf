locals {
  public_count              = "${var.enabled == "true" && var.type == "public" ? length(var.availability_zones) : 0}"
  public_nat_gateways_count = "${var.enabled == "true" && var.type == "public" && var.nat_gateway_enabled == "true" ? length(var.availability_zones) : 0}"
}

module "public_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.0"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  tags       = "${var.tags}"
  attributes = ["${compact(concat(var.attributes, list("public")))}"]
  enabled    = "${var.enabled}"
}

resource "aws_subnet" "public" {
  count             = "${local.public_count}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)}"

  tags = "${
    merge(
      module.public_label.tags,
      map(
        "Name", "${module.public_label.id}${var.delimiter}${element(var.availability_zones, count.index)}",
        "AZ", "${element(var.availability_zones, count.index)}",
        "Type", "${var.type}"
      )
    )
  }"
}

resource "aws_network_acl" "public" {
  count      = "${var.enabled == "true" && var.type == "public" && signum(length(var.public_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.public.*.id}"]
  egress     = "${var.public_network_acl_egress}"
  ingress    = "${var.public_network_acl_ingress}"
  tags       = "${module.public_label.tags}"
  depends_on = ["aws_subnet.public"]
}

resource "aws_route_table" "public" {
  count  = "${local.public_count}"
  vpc_id = "${var.vpc_id}"

  tags = "${
    merge(
      module.public_label.tags,
      map(
        "Name", "${module.public_label.id}${var.delimiter}${element(var.availability_zones, count.index)}",
        "AZ", "${element(var.availability_zones, count.index)}",
        "Type", "${var.type}"
      )
    )
  }"
}

resource "aws_route" "public" {
  count                  = "${local.public_count}"
  route_table_id         = "${element(aws_route_table.public.*.id, count.index)}"
  gateway_id             = "${var.igw_id}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.public"]
}

resource "aws_route_table_association" "public" {
  count          = "${local.public_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.public.*.id, count.index)}"
  depends_on     = ["aws_subnet.public", "aws_route_table.public"]
}

resource "aws_eip" "public" {
  count = "${local.public_nat_gateways_count}"
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "public" {
  count         = "${local.public_nat_gateways_count}"
  allocation_id = "${element(aws_eip.public.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  depends_on    = ["aws_subnet.public"]

  lifecycle {
    create_before_destroy = true
  }

  tags = "${
    merge(
      module.public_label.tags,
      map(
        "Name", "${module.public_label.id}${var.delimiter}${element(var.availability_zones, count.index)}",
        "AZ", "${element(var.availability_zones, count.index)}",
        "Type", "${var.type}"
      )
    )
  }"
}

# Dummy list of NAT Gateway IDs to use in the outputs for private subnets and when `nat_gateway_enabled=false` for public subnets
# Needed due to Terraform limitation of not allowing using conditionals with maps and lists
locals {
  dummy_az_ngw_ids = ["${slice(list("0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0"), 0, length(var.availability_zones))}"]
}
