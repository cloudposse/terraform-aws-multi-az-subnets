locals {
  private_count       = "${var.enabled == "true" && var.type == "private" ? length(var.availability_zones) : 0}"
  private_route_count = "${var.enabled == "true" && var.type == "private" ? var.az_ngw_count : 0}"
}

module "private_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.0"
  namespace  = "${var.namespace}"
  name       = "${var.name}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  tags       = "${var.tags}"
  attributes = ["${compact(concat(var.attributes, list("private")))}"]
  enabled    = "${var.enabled}"
}

resource "aws_subnet" "private" {
  count             = "${local.private_count}"
  vpc_id            = "${var.vpc_id}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)}"

  tags = "${
    merge(
      module.private_label.tags,
      map(
        "Name", "${module.private_label.id}${var.delimiter}${element(var.availability_zones, count.index)}",
        "AZ", "${element(var.availability_zones, count.index)}",
        "Type", "${var.type}"
      )
    )
  }"
}

resource "aws_network_acl" "private" {
  count      = "${var.enabled == "true" && var.type == "private" && signum(length(var.private_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${var.vpc_id}"
  subnet_ids = ["${aws_subnet.private.*.id}"]
  egress     = "${var.private_network_acl_egress}"
  ingress    = "${var.private_network_acl_ingress}"
  tags       = "${module.private_label.tags}"
  depends_on = ["aws_subnet.private"]
}

resource "aws_route_table" "private" {
  count  = "${local.private_count}"
  vpc_id = "${var.vpc_id}"

  tags = "${
    merge(
     module.private_label.tags,
     map(
        "Name", "${module.private_label.id}${var.delimiter}${element(var.availability_zones, count.index)}",
        "AZ", "${element(var.availability_zones, count.index)}",
        "Type", "${var.type}"
      )
    )
  }"
}

resource "aws_route_table_association" "private" {
  count          = "${local.private_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  depends_on     = ["aws_subnet.private", "aws_route_table.private"]
}

resource "aws_route" "default" {
  count                  = "${local.private_route_count}"
  route_table_id         = "${lookup(zipmap(var.availability_zones, matchkeys(aws_route_table.private.*.id, aws_route_table.private.*.tags.AZ, var.availability_zones)), element(keys(var.az_ngw_ids), count.index))}"
  nat_gateway_id         = "${lookup(var.az_ngw_ids, element(keys(var.az_ngw_ids), count.index))}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
}
