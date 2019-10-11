provider "aws" {
  region = var.region
}

locals {
  public_cidr_block  = cidrsubnet(var.cidr_block, 1, 0)
  private_cidr_block = cidrsubnet(var.cidr_block, 1, 1)
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.0"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = var.cidr_block
}

module "public_subnets" {
  source              = "../../"
  namespace           = var.namespace
  stage               = var.stage
  name                = var.name
  availability_zones  = var.availability_zones
  vpc_id              = module.vpc.vpc_id
  cidr_block          = local.public_cidr_block
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = true
}

module "private_subnets" {
  source             = "../../"
  namespace          = var.namespace
  stage              = var.stage
  name               = var.name
  availability_zones = var.availability_zones
  vpc_id             = module.vpc.vpc_id
  cidr_block         = local.private_cidr_block
  type               = "private"

  # Map of AZ names to NAT Gateway IDs that was created in "public_subnets" module
  az_ngw_ids = module.public_subnets.az_ngw_ids
}

