locals {
  private_count              = "${var.enabled == "true" && var.type == "private" ? length(var.az_ngw_ids) : 0}"
  private_nat_gateways_count = "${var.enabled == "true" && var.type == "private" && var.nat_gateway_enabled == "true" ? length(var.az_ngw_ids) : 0}"
  az_names                   = "${keys(var.az_ngw_ids)}"
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
  vpc_id            = "${data.aws_vpc.default.id}"
  availability_zone = "${element(local.az_names, count.index)}"
  cidr_block        = "${cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), count.index)}"

  tags = "${
    merge(
      module.private_label.tags,
      map(
        "Name", "${module.private_label.id}${var.delimiter}${element(local.az_names, count.index)}",
        "AZ", "${element(local.az_names, count.index)}",
        "Type", "${var.type}"
      )
    )
  }"
}

resource "aws_network_acl" "private" {
  count      = "${var.enabled == "true" && var.type == "private" && signum(length(var.private_network_acl_id)) == 0 ? 1 : 0}"
  vpc_id     = "${data.aws_vpc.default.id}"
  subnet_ids = ["${aws_subnet.private.*.id}"]
  egress     = "${var.private_network_acl_egress}"
  ingress    = "${var.private_network_acl_ingress}"
  tags       = "${module.private_label.tags}"
  depends_on = ["aws_subnet.private"]
}

resource "aws_route_table" "private" {
  count  = "${local.private_nat_gateways_count}"
  vpc_id = "${data.aws_vpc.default.id}"

  tags = "${
    merge(
     module.private_label.tags,
     map(
        "Name", "${module.private_label.id}${var.delimiter}${element(local.az_names, count.index)}",
        "AZ", "${element(local.az_names, count.index)}",
        "Type", "${var.type}"
      )
    )
  }"
}

resource "aws_route_table_association" "private" {
  count          = "${local.private_nat_gateways_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  depends_on     = ["aws_subnet.private", "aws_route_table.private"]
}

resource "aws_route" "default" {
  count                  = "${local.private_nat_gateways_count}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  nat_gateway_id         = "${lookup(var.az_ngw_ids, element(local.az_names, count.index))}"
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = ["aws_route_table.private"]
}
