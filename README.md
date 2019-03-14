<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->
[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

# terraform-aws-multi-az-subnets [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-multi-az-subnets) [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-multi-az-subnets.svg)](https://github.com/cloudposse/terraform-aws-multi-az-subnets/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


Terraform module for multi-AZ [`subnets`](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) provisioning.

The module creates private and public subnets in the provided Availability Zones.

The public subnets are routed to the Internet Gateway specified by `var.igw_id`.

`nat_gateway_enabled` flag controls the creation of NAT Gateways in the public subnets.

The private subnets are routed to the NAT Gateways provided in the `var.az_ngw_ids` map.


---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps. 
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]




It's 100% Open Source and licensed under the [APACHE2](LICENSE).











## Screenshots


![terraform-aws-multi-az-subnets](images/terraform-aws-multi-az-subnets.png)
*Example of `terraform apply` outputs*



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




## Examples

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
<br/>



## Makefile Targets
```
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| availability_zones | List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`) | list | `<list>` | no |
| az_ngw_count | Count of items in the `az_ngw_ids` map. Needs to be explicitly provided since Terraform currently can't use dynamic count on computed resources from different modules. https://github.com/hashicorp/terraform/issues/10857 | string | `0` | no |
| az_ngw_ids | Only for private subnets. Map of AZ names to NAT Gateway IDs that are used as default routes when creating private subnets | map | `<map>` | no |
| cidr_block | Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`) | string | - | yes |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| enabled | Set to false to prevent the module from creating any resources | string | `true` | no |
| igw_id | Internet Gateway ID that is used as a default route when creating public subnets (e.g. `igw-9c26a123`) | string | `` | no |
| max_subnets | Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation | string | `6` | no |
| name | Application or solution name | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| nat_gateway_enabled | Flag to enable/disable NAT Gateways creation in public subnets | string | `true` | no |
| private_network_acl_egress | Egress network ACL rules | list | `<list>` | no |
| private_network_acl_id | Network ACL ID that is added to the private subnets. If empty, a new ACL will be created | string | `` | no |
| private_network_acl_ingress | Egress network ACL rules | list | `<list>` | no |
| public_network_acl_egress | Egress network ACL rules | list | `<list>` | no |
| public_network_acl_id | Network ACL ID that is added to the public subnets. If empty, a new ACL will be created | string | `` | no |
| public_network_acl_ingress | Egress network ACL rules | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| type | Type of subnets to create (`private` or `public`) | string | `private` | no |
| vpc_id | VPC ID | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| az_ngw_ids | Map of AZ names to NAT Gateway IDs (only for public subnets) |
| az_route_table_ids | Map of AZ names to Route Table IDs |
| az_subnet_arns | Map of AZ names to subnet arns |
| az_subnet_ids | Map of AZ names to subnet IDs |




## Share the Love 

Like this project? Please give it a ★ on [our GitHub](https://github.com/cloudposse/terraform-aws-multi-az-subnets)! (it helps us **a lot**) 

Are you using this project or any of our other projects? Consider [leaving a testimonial][testimonial]. =)


## Related Projects

Check out these related projects.

- [terraform-aws-named-subnets](https://github.com/cloudposse/terraform-aws-named-subnets) - Terraform module for named subnets provisioning.
- [terraform-aws-dynamic-subnets](https://github.com/cloudposse/terraform-aws-dynamic-subnets) - Terraform module for public and private subnets provisioning in existing VPC
- [terraform-aws-vpc](https://github.com/cloudposse/terraform-aws-vpc) - Terraform Module that defines a VPC with public/private subnets across multiple AZs with Internet Gateways
- [terraform-aws-cloudwatch-flow-logs](https://github.com/cloudposse/terraform-aws-cloudwatch-flow-logs) - Terraform module for enabling flow logs for vpc and subnets.



## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-multi-az-subnets/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## Commercial Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide [*commercial support*][commercial_support] for all of our [Open Source][github] projects. As a *Dedicated Support* customer, you have access to our team of subject matter experts at a fraction of the cost of a full-time engineer. 

[![E-Mail](https://img.shields.io/badge/email-hello@cloudposse.com-blue.svg)][email]

- **Questions.** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting.** We'll help you triage why things aren't working.
- **Code Reviews.** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes.** We'll rapidly work to fix any bugs in our projects.
- **Build New Terraform Modules.** We'll [develop original modules][module_development] to provision infrastructure.
- **Cloud Architecture.** We'll assist with your cloud strategy and design.
- **Implementation.** We'll provide hands-on support to implement our reference architectures. 




## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Newsletter

Signup for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover. 

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-multi-az-subnets/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://cpco.io/help-out) with our other projects, we would love to hear from you! Shoot us an [email][email].

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2019 [Cloud Posse, LLC](https://cpco.io/copyright)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.  

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

|  [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] |
|---|

  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://github.com/aknysh.png?size=150



[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs
  [website]: https://cpco.io/homepage
  [github]: https://cpco.io/github
  [jobs]: https://cpco.io/jobs
  [hire]: https://cpco.io/hire
  [slack]: https://cpco.io/slack
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://cpco.io/twitter
  [testimonial]: https://cpco.io/leave-testimonial
  [newsletter]: https://cpco.io/newsletter
  [email]: https://cpco.io/email
  [commercial_support]: https://cpco.io/commercial-support
  [we_love_open_source]: https://cpco.io/we-love-open-source
  [module_development]: https://cpco.io/module-development
  [terraform_modules]: https://cpco.io/terraform-modules
  [readme_header_img]: https://cloudposse.com/readme/header/img?repo=cloudposse/terraform-aws-multi-az-subnets
  [readme_header_link]: https://cloudposse.com/readme/header/link?repo=cloudposse/terraform-aws-multi-az-subnets
  [readme_footer_img]: https://cloudposse.com/readme/footer/img?repo=cloudposse/terraform-aws-multi-az-subnets
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?repo=cloudposse/terraform-aws-multi-az-subnets
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img?repo=cloudposse/terraform-aws-multi-az-subnets
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?repo=cloudposse/terraform-aws-multi-az-subnets
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-multi-az-subnets&url=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-multi-az-subnets&url=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_email]: mailto:?subject=terraform-aws-multi-az-subnets&body=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-multi-az-subnets?pixel&cs=github&cm=readme&an=terraform-aws-multi-az-subnets
