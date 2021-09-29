provider "aws" {
  region = var.region
}

locals {
  public_cidr_block       = cidrsubnet(var.cidr_block, 2, 0)
  public_only_cidr_block  = cidrsubnet(var.cidr_block, 2, 1)
  private_cidr_block      = cidrsubnet(var.cidr_block, 2, 2)
  private_only_cidr_block = cidrsubnet(var.cidr_block, 2, 3)
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.21.1"

  cidr_block = var.cidr_block

  context = module.this.context
}

module "public_subnets" {
  source = "../../"

  availability_zones  = var.availability_zones
  vpc_id              = module.vpc.vpc_id
  cidr_block          = local.public_cidr_block
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = true
  ipv6_enabled        = true
  ipv6_cidr_block     = var.ipv6_cidr_block

  context = module.this.context
}

module "public_only_subnets" {
  source = "../../"

  availability_zones  = var.availability_zones
  vpc_id              = module.vpc.vpc_id
  cidr_block          = local.public_only_cidr_block
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = false
  ipv6_enabled        = true
  ipv6_cidr_block     = module.vpc.ipv6_cidr_block

  context = module.this.context
}

module "private_subnets" {
  source = "../../"

  availability_zones = var.availability_zones
  vpc_id             = module.vpc.vpc_id
  cidr_block         = local.private_cidr_block
  type               = "private"

  # Map of AZ names to NAT Gateway IDs that was created in "public_subnets" module
  az_ngw_ids = module.public_subnets.az_ngw_ids

  context = module.this.context
}

module "private_only_subnets" {
  source = "../../"

  availability_zones = var.availability_zones
  vpc_id             = module.vpc.vpc_id
  cidr_block         = local.private_only_cidr_block
  type               = "private"

  # No NAT gateways supplied, should create subnets with empty route tables
  # az_ngw_ids = module.public_subnets.az_ngw_ids

  context = module.this.context
}

