locals {
  private_cidr_block = "${cidrsubnet(var.cidr_block, 1, 0)}"
}

module "private_subnets" {
  source             = "../../"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id             = "${var.vpc_id}"
  cidr_block         = "${local.private_cidr_block}"
  type               = "private"
}
