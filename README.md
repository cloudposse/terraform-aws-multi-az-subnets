# terraform-aws-multi-az-subnets [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets.svg)](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets)

Terraform module for multi-AZ [`subnets`](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) provisioning.

The module creates private or public subnets in the Availability Zones.

The public subnets are routed to the Internet Gateway specified by `var.igw_id`.

The private subnets are routed to the NAT Gateways provided in the `var.az_ngw_ids` map.


## Usage

```hcl
module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "${var.namespace}"
  name       = "vpc"
  stage      = "${var.stage}"
  cidr_block = "${var.cidr_block}"
}

locals {
  public_cidr_block  = "${cidrsubnet(module.vpc.vpc_cidr_block, 1, 0)}"
  private_cidr_block = "${cidrsubnet(module.vpc.vpc_cidr_block, 1, 1)}"
}

module "public_subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=master"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "${var.name}"
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id              = "${module.vpc.vpc_id}"
  cidr_block          = "${local.public_cidr_block}"
  type                = "public"
  igw_id              = "${module.vpc.igw_id}"
  nat_gateway_enabled = "true"
}

module "private_subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=master"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "${var.name}"
  vpc_id              = "${module.vpc.vpc_id}"
  cidr_block          = "${local.private_cidr_block}"
  type                = "private"
  # Map of AZ names to NAT Gateway IDs was created in "public_subnets" module. Assign it to `az_ngw_ids` input
  az_ngw_ids          = "${module.public_subnets.az_ngw_ids}"
  nat_gateway_enabled = "true"
}
```


# Inputs

| Name                          | Default               | Description                                                                                                                                                                               | Required |
|:------------------------------|:---------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                   | ``                    | Namespace (_e.g._ `cp` or `cloudposse`)                                                                                                                                                   |   Yes    |
| `stage`                       | ``                    | Stage (_e.g._ `prod`, `dev`, `staging`)                                                                                                                                                   |   Yes    |
| `name`                        | ``                    | Application or solution name (_e.g._ `myapp`)                                                                                                                                             |   Yes    |
| `delimiter`                   | `-`                   | Delimiter to use between `name`, `namespace`, `stage`, `attributes`                                                                                                                       |    No    |
| `attributes`                  | `[]`                  | Additional attributes (_e.g._ `policy` or `role`)                                                                                                                                         |    No    |
| `tags`                        | `{}`                  | Additional tags  (_e.g._ `map("BusinessUnit","XYZ")`                                                                                                                                      |    No    |
| `max_subnets`                 | `16`                  | Maximum number of subnets that can be created. This variable is used for CIDR blocks calculation. MUST be greater than the length of `availability_zones` list                            |   Yes    |
| `availability_zones`          | []                    | Only for public subnets. List of Availability Zones to create public subnets (e.g. `["us-east-1a", "us-east-1b", "us-east-1c"]`)                                                          |   Yes    |
| `type`                        | `private`             | Type of subnets to create (`private` or `public`)                                                                                                                                         |   Yes    |
| `vpc_id`                      | ``                    | VPC ID where subnets are created (_e.g._ `vpc-aceb2723`)                                                                                                                                  |   Yes    |
| `cidr_block`                  | ``                    | Base CIDR block which is divided into subnet CIDR blocks (_e.g._ `10.0.0.0/24`)                                                                                                           |    No    |
| `igw_id`                      | ``                    | Only for public subnets. Internet Gateway ID which is used as a default route in public route tables when creating public subnets (_e.g._ `igw-9c26a123`)                                 |   Yes    |
| `az_ngw_ids`                  | {}                    | Only for private subnets. Map of AZ names to NAT Gateway IDs which are used as default routes in private route tables when creating private subnets                                       |    No    |
| `public_network_acl_id`       | ``                    | ID of Network ACL which is added to the public subnets. If empty, a new ACL will be created                                                                                               |    No    |
| `private_network_acl_id`      | ``                    | ID of Network ACL which is added to the private subnets. If empty, a new ACL will be created                                                                                              |    No    |
| `public_network_acl_egress`   | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Egress rules which are added to the new Public Network ACL                                         |    No    |
| `public_network_acl_ingress`  | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Ingress rules which are added to the new Public Network ACL                                        |    No    |
| `private_network_acl_egress`  | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Egress rules which are added to the new Private Network ACL                                        |    No    |
| `private_network_acl_ingress` | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Ingress rules which are added to the new Private Network ACL                                       |    No    |
| `enabled`                     | `true`                | Set to `false` to prevent the module from creating any resources                                                                                                                          |    No    |
| `nat_gateway_enabled`         | `true`                | Flag to enable/disable NAT Gateways for public subnets, and to enable/disable routing to NAT Gateways for private subnets                                                                 |    No    |


## Outputs

| Name                      | Description                                                                                            |
|:--------------------------|:-------------------------------------------------------------------------------------------------------|
| az_subnet_ids             | Map of AZ names to subnet IDs                                                                          |
| az_route_table_ids        | Map of AZ names to Route Table IDs                                                                     |
| az_ngw_ids                | Map of AZ names to NAT Gateway IDs (only for public subnets; for private subnets returns an empty map) |


Given the following configuration

```hcl
locals {
  public_cidr_block  = "${cidrsubnet(var.vpc_cidr, 1, 0)}"
  private_cidr_block = "${cidrsubnet(var.vpc_cidr, 1, 1)}"
}

module "public_subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=master"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "${var.name}"
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id              = "${module.vpc.vpc_id}"
  cidr_block          = "${local.public_cidr_block}"
  type                = "public"
  igw_id              = "${module.vpc.igw_id}"
  nat_gateway_enabled = "true"
}

module "private_subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=master"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "${var.name}"
  vpc_id              = "${module.vpc.vpc_id}"
  cidr_block          = "${local.private_cidr_block}"
  type                = "private"
  az_ngw_ids          = "${module.public_subnets.az_ngw_ids}"
  nat_gateway_enabled = "true"
}

output "private_az_subnet_ids" {
  value = "${module.private_subnets.az_subnet_ids}"
}

output "public_az_subnet_ids" {
  value = "${module.public_subnets.az_subnet_ids}"
}
```

the output Maps of AZ names to subnet IDs look like these

```hcl
public_az_subnet_ids = {
  us-east-1a = subnet-ea58d78e
  us-east-1b = subnet-556ee131
  us-east-1c = subnet-6f54db0b
}
private_az_subnet_ids = {
  us-east-1a = subnet-376de253
  us-east-1b = subnet-9e53dcfa
  us-east-1c = subnet-a86fe0cc
}
```

and the created subnet IDs could be found by the AZ names using `map["key"]` or [`lookup(map, key, [default])`](https://www.terraform.io/docs/configuration/interpolation.html#lookup-map-key-default-),

for example:

`public_az_subnet_ids["us-east-1a"]`

`lookup(private_az_subnet_ids, "us-east-1b")`


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
