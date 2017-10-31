# terraform-aws-multi-az-subnets [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets.svg)](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets)

Terraform module for named [`subnets`](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) provisioning.


## Usage

Simple example with private and public subnets in one Availability Zone:

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
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["web1", "web2", "web3"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.public_cidr_block}"
  type              = "public"
  igw_id            = "${module.vpc.igw_id}"
  availability_zone = "us-east-1a"
}

module "private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["kafka", "cassandra", "zookeeper"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1a"
  ngw_id            = "${module.public_subnets.ngw_id}"
}
```

Full example, with private and public subnets in two Availability Zones for High Availability:

```hcl
module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=master"
  namespace  = "${var.namespace}"
  name       = "vpc"
  stage      = "${var.stage}"
  cidr_block = "${var.cidr_block}"
}

locals {
  us_east_1a_public_cidr_block  = "${cidrsubnet(module.vpc.vpc_cidr_block, 2, 0)}"
  us_east_1a_private_cidr_block = "${cidrsubnet(module.vpc.vpc_cidr_block, 2, 1)}"
  us_east_1b_public_cidr_block  = "${cidrsubnet(module.vpc.vpc_cidr_block, 2, 2)}"
  us_east_1b_private_cidr_block = "${cidrsubnet(module.vpc.vpc_cidr_block, 2, 3)}"
}

module "us_east_1a_public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["apples", "oranges", "grapes"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1a_public_cidr_block}"
  type              = "public"
  igw_id            = "${module.vpc.igw_id}"
  availability_zone = "us-east-1a"
  attributes        = ["us-east-1a"]
}

module "us_east_1a_private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["charlie", "echo", "bravo"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1a_private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1a"
  ngw_id            = "${module.us_east_1a_public_subnets.ngw_id}"
  attributes        = ["us-east-1a"]
}

module "us_east_1b_public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["apples", "oranges", "grapes"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1b_public_cidr_block}"
  type              = "public"
  igw_id            = "${module.vpc.igw_id}"
  availability_zone = "us-east-1b"
  attributes        = ["us-east-1b"]
}

module "us_east_1b_private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["charlie", "echo", "bravo"]
  vpc_id            = "${module.vpc.vpc_id}"
  cidr_block        = "${local.us_east_1b_private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1b"
  ngw_id            = "${module.us_east_1b_public_subnets.ngw_id}"
  attributes        = ["us-east-1b"]
}
```

# Inputs

| Name                          | Default               | Description                                                                                                                                                                               | Required |
|:------------------------------|:---------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------:|
| `namespace`                   | ``                    | Namespace (_e.g._ `cp` or `cloudposse`)                                                                                                                                                   |   Yes    |
| `stage`                       | ``                    | Stage (_e.g._ `prod`, `dev`, `staging`)                                                                                                                                                   |   Yes    |
| `name`                        | ``                    | Application or solution name (_e.g._ `myapp`)                                                                                                                                        |   Yes    |
| `delimiter`                   | `-`                   | Delimiter to use between `name`, `namespace`, `stage`, `attributes`                                                                                                                       |    No    |
| `attributes`                  | `[]`                  | Additional attributes (_e.g._ `policy` or `role`)                                                                                                                                         |    No    |
| `tags`                        | `{}`                  | Additional tags  (_e.g._ `map("BusinessUnit","XYZ")`                                                                                                                                      |    No    |
| `subnet_names`                | ``                    | List of subnet names (_e.g._ `["kafka", "cassandra", "zookeeper"]`)                                                                                                                       |   Yes    |
| `max_subnets`                 | `16`                  | Maximum number of subnets that can be created. This variable is being used for CIDR blocks calculation. MUST be greater than length of `names` list                                       |    No    |
| `availability_zone`           | ``                    | Availability Zone where subnets will be created (e.g. `us-east-1a`)                                                                                                                       |   Yes    |
| `type`                        | `private`             | Type of subnets (`private` or `public`)                                                                                                                                                   |    No    |
| `vpc_id`                      | ``                    | VPC ID where subnets will be created (_e.g._ `vpc-aceb2723`)                                                                                                                              |   Yes    |
| `cidr_block`                  | ``                    | Base CIDR block which will be divided into subnet CIDR blocks (_e.g._ `10.0.0.0/24`)                                                                                                      |    No    |
| `igw_id`                      | ``                    | Internet Gateway ID which will be used as a default route in public route tables (_e.g._ `igw-9c26a123`)                                                                                  |   Yes    |
| `ngw_id`                      | ``                    | NAT Gateway ID which will be used as a default route in private route tables (_e.g._ `igw-9c26a123`)                                                                                      |   Yes    |
| `public_network_acl_id`       | ``                    | ID of Network ACL which will be added to the public subnets. If empty, a new ACL will be created                                                                                          |    No    |
| `private_network_acl_id`      | ``                    | ID of Network ACL which will be added to the private subnets. If empty, a new ACL will be created                                                                                         |    No    |
| `public_network_acl_egress`   | see [variables.tf](https://github.com/cloudposse/terraform-aws-named-subnets/blob/master/variables.tf)    | Egress rules which will be added to the new Public Network ACL                                        |    No    |
| `public_network_acl_ingress`  | see [variables.tf](https://github.com/cloudposse/terraform-aws-named-subnets/blob/master/variables.tf)    | Ingress rules which will be added to the new Public Network ACL                                       |    No    |
| `private_network_acl_egress`  | see [variables.tf](https://github.com/cloudposse/terraform-aws-named-subnets/blob/master/variables.tf)    | Egress rules which will be added to the new Private Network ACL                                       |    No    |
| `private_network_acl_ingress` | see [variables.tf](https://github.com/cloudposse/terraform-aws-named-subnets/blob/master/variables.tf)    | Ingress rules which will be added to the new Private Network ACL                                      |    No    |


## Outputs

| Name                      | Description                                  |
|:--------------------------|:---------------------------------------------|
| ngw_id                    | NAT Gateway ID                               |
| ngw_private_ip            | Private IP address of the NAT Gateway        |
| ngw_public_ip             | Public IP address of the NAT Gateway         |
| route_table_ids           | Route Table IDs                              |
| subnet_ids                | Subnet IDs                                   |
| named_subnet_ids          | Map of subnet names to subnet IDs            |


Given the following configuration (see the Simple example above)

```hcl
locals {
  public_cidr_block  = "${cidrsubnet(var.vpc_cidr, 1, 0)}"
  private_cidr_block = "${cidrsubnet(var.vpc_cidr, 1, 1)}"
}

module "public_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["web1", "web2", "web3"]
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${local.public_cidr_block}"
  type              = "public"
  availability_zone = "us-east-1a"
  igw_id            = "${var.igw_id}"
}

module "private_subnets" {
  source            = "git::https://github.com/cloudposse/terraform-aws-named-subnets.git?ref=master"
  namespace         = "${var.namespace}"
  stage             = "${var.stage}"
  name              = "${var.name}"
  subnet_names      = ["kafka", "cassandra", "zookeeper"]
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${local.private_cidr_block}"
  type              = "private"
  availability_zone = "us-east-1a"
  ngw_id            = "${module.public_subnets.ngw_id}"
}

output "private_named_subnet_ids" {
  value = "${module.private_subnets.named_subnet_ids}"
}

output "public_named_subnet_ids" {
  value = "${module.public_subnets.named_subnet_ids}"
}
```

the output Maps of subnet names to subnet IDs will look like these

```hcl
public_named_subnet_ids = {
  web1 = subnet-ea58d78e
  web2 = subnet-556ee131
  web3 = subnet-6f54db0b
}
private_named_subnet_ids = {
  cassandra = subnet-376de253
  kafka = subnet-9e53dcfa
  zookeeper = subnet-a86fe0cc
}
```

and the created subnet IDs could be found by the subnet names using `map["key"]` or [`lookup(map, key, [default])`](https://www.terraform.io/docs/configuration/interpolation.html#lookup-map-key-default-), for example:

`public_named_subnet_ids["web1"]`

`lookup(private_named_subnet_ids, "kafka")`


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.
