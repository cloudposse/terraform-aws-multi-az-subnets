# terraform-aws-multi-az-subnets [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets)

Terraform module for multi-AZ [`subnets`](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) provisioning.

The module creates private and public subnets in the provided Availability Zones.

The public subnets are routed to the Internet Gateway specified by `var.igw_id`.

`nat_gateway_enabled` flag controls the creation of NAT Gateways in the public subnets.

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
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id              = "${module.vpc.vpc_id}"
  cidr_block          = "${local.private_cidr_block}"
  type                = "private"

  # Map of AZ names to NAT Gateway IDs that was created in "public_subnets" module
  az_ngw_ids          = "${module.public_subnets.az_ngw_ids}"

  # Need to explicitly provide the count since Terraform currently can't use dynamic count on computed resources from different modules
  # https://github.com/hashicorp/terraform/issues/10857
  # https://github.com/hashicorp/terraform/issues/12125
  # https://github.com/hashicorp/terraform/issues/4149
  az_ngw_count = 3
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
| `availability_zones`          | []                    | List of Availability Zones (e.g. `["us-east-1a", "us-east-1b", "us-east-1c"]`)                                                                                                            |   Yes    |
| `type`                        | `private`             | Type of subnets to create (`private` or `public`)                                                                                                                                         |   Yes    |
| `vpc_id`                      | ``                    | VPC ID where subnets are created (_e.g._ `vpc-aceb2723`)                                                                                                                                  |   Yes    |
| `cidr_block`                  | ``                    | Base CIDR block which is divided into subnet CIDR blocks (_e.g._ `10.0.0.0/24`)                                                                                                           |    No    |
| `igw_id`                      | ``                    | Only for public subnets. Internet Gateway ID which is used as a default route when creating public subnets (_e.g._ `igw-9c26a123`)                                                        |   Yes    |
| `public_network_acl_id`       | ``                    | ID of Network ACL which is added to the public subnets. If empty, a new ACL will be created                                                                                               |    No    |
| `private_network_acl_id`      | ``                    | ID of Network ACL which is added to the private subnets. If empty, a new ACL will be created                                                                                              |    No    |
| `public_network_acl_egress`   | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Egress rules which are added to the new Public Network ACL                                         |    No    |
| `public_network_acl_ingress`  | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Ingress rules which are added to the new Public Network ACL                                        |    No    |
| `private_network_acl_egress`  | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Egress rules which are added to the new Private Network ACL                                        |    No    |
| `private_network_acl_ingress` | see [variables.tf](https://github.com/cloudposse/terraform-aws-multi-az-subnets/blob/master/variables.tf)    | Ingress rules which are added to the new Private Network ACL                                       |    No    |
| `enabled`                     | `true`                | Set to `false` to prevent the module from creating any resources                                                                                                                          |    No    |
| `nat_gateway_enabled`         | `true`                | Flag to enable/disable NAT Gateways creation in public subnets                                                                                                                            |    No    |
| `az_ngw_ids`                  | {}                    | Map of AZ names to NAT Gateway IDs which are used as default routes when creating private subnets. Only for private subnets                                                               |    No    |
| `az_ngw_count`                | 0                     | Count of items in the `az_ngw_ids` map. Needs to be explicitly provided since Terraform currently can't use dynamic count on computed resources from different modules. https://github.com/hashicorp/terraform/issues/10857    |    No    |


## Outputs

| Name                      | Description                                                    |
|:--------------------------|:---------------------------------------------------------------|
| az_subnet_ids             | Map of AZ names to subnet IDs                                  |
| az_route_table_ids        | Map of AZ names to Route Table IDs                             |
| az_ngw_ids                | Map of AZ names to NAT Gateway IDs (only for public subnets)   |


Given the following configuration

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
  availability_zones  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_id              = "${module.vpc.vpc_id}"
  cidr_block          = "${local.private_cidr_block}"
  type                = "private"
  az_ngw_ids          = "${module.public_subnets.az_ngw_ids}"
  az_ngw_count        = 3
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


## Example of `terraform apply` outputs

![terraform-aws-multi-az-subnets](images/terraform-aws-multi-az-subnets.png)


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-multi-az-subnets/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Gitter](https://gitter.im/cloudposse/).


## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-multi-az-subnets/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing `terraform-aws-multi-az-subnets`, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!


## License

[APACHE 2.0](LICENSE) © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


## About

`terraform-aws-multi-az-subnets` is maintained and funded by [Cloud Posse, LLC][website].

![Cloud Posse](https://cloudposse.com/logo-300x69.png)


Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)!

See [our other projects][community]
or [hire us][hire] to help build your next cloud platform.

  [website]: https://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: https://cloudposse.com/contact/


### Contributors

| [![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] | [![Andriy Knysh][andriy_img]][andriy_web]<br/>[Andriy Knysh][andriy_web] |
|-------------------------------------------------------|------------------------------------------------------------------|

  [erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
  [erik_web]: https://github.com/osterman/
  [andriy_img]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
  [andriy_web]: https://github.com/aknysh/
