# terraform-aws-multi-az-subnets [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets.svg)](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets)

Terraform module for multi-AZ [`subnets`](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) provisioning.

The module creates one private or public subnet (specified by `var.type`) in each Availability Zone specified in `var.availability_zones`.
The public subnets are routed to the Internet Gateway (using the provided Internet Gateway ID).
The private subnets are routed to the NAT Gateway (using the provided NAT Gateway ID).


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
  source             = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=master"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_block         = "${local.public_cidr_block}"
  type               = "public"
  igw_id             = "${module.vpc.igw_id}"
}

module "private_subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=master"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_block         = "${local.private_cidr_block}"
  type               = "private"
  ngw_id             = "${module.public_subnets.ngw_id}"
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
| `availability_zones`          | ``                    | List of Availability Zones where subnets are created (e.g. `["us-east-1a", "us-east-1b", "us-east-1c"]`)                                                                                  |   Yes    |
| `type`                        | `private`             | Type of subnets (`private` or `public`)                                                                                                                                                   |    No    |
| `vpc_id`                      | ``                    | VPC ID where subnets are created (_e.g._ `vpc-aceb2723`)                                                                                                                                  |   Yes    |
| `cidr_block`                  | ``                    | Base CIDR block which is divided into subnet CIDR blocks (_e.g._ `10.0.0.0/24`)                                                                                                           |    No    |
| `igw_id`                      | ``                    | Internet Gateway ID which is used as a default route in public route tables (_e.g._ `igw-9c26a123`)                                                                                       |   Yes    |
| `ngw_id`                      | ``                    | NAT Gateway ID which is used as a default route in private route tables (_e.g._ `igw-9c26a123`)                                                                                           |   Yes    |
| `public_network_acl_id`       | ``                    | ID of Network ACL which is added to the public subnets. If empty, a new ACL will be created                                                                                               |    No    |
| `private_network_acl_id`      | ``                    | ID of Network ACL which is added to the private subnets. If empty, a new ACL will be created                                                                                              |    No    |
| `public_network_acl_egress`   | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Egress rules which are added to the new Public Network ACL                                         |    No    |
| `public_network_acl_ingress`  | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Ingress rules which are added to the new Public Network ACL                                        |    No    |
| `private_network_acl_egress`  | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Egress rules which are added to the new Private Network ACL                                        |    No    |
| `private_network_acl_ingress` | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Ingress rules which are added to the new Private Network ACL                                       |    No    |


## Outputs

| Name                      | Description                                  |
|:--------------------------|:---------------------------------------------|
| ngw_id                    | NAT Gateway ID                               |
| ngw_private_ip            | Private IP address of the NAT Gateway        |
| ngw_public_ip             | Public IP address of the NAT Gateway         |
| route_table_ids           | Route Table IDs                              |
| subnet_ids                | Subnet IDs                                   |
| az_subnet_ids             | Map of AZ names to subnet IDs                |


Given the following configuration (see the Simple example above)

```hcl
locals {
  public_cidr_block  = "${cidrsubnet(var.vpc_cidr, 1, 0)}"
  private_cidr_block = "${cidrsubnet(var.vpc_cidr, 1, 1)}"
}

module "public_subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=master"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_block         = "${local.public_cidr_block}"
  type               = "public"
  igw_id             = "${module.vpc.igw_id}"
}

module "private_subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=master"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  name               = "${var.name}"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id             = "${module.vpc.vpc_id}"
  cidr_block         = "${local.private_cidr_block}"
  type               = "private"
  ngw_id             = "${module.public_subnets.ngw_id}"
}

output "private_az_subnet_ids" {
  value = "${module.private_subnets.az_subnet_ids}"
}

output "public_az_subnet_ids" {
  value = "${module.public_subnets.az_subnet_ids}"
}
```

the output Maps of AZ names to subnet IDs will look like these

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

and the created subnet IDs could be found by the subnet names using `map["key"]` or [`lookup(map, key, [default])`](https://www.terraform.io/docs/configuration/interpolation.html#lookup-map-key-default-),

for example:

`public_az_subnet_ids["us-east-1a"]`

`lookup(private_az_subnet_ids, "us-east-1b")`


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
