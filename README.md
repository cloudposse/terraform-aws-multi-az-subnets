
<!-- markdownlint-disable -->
# terraform-aws-multi-az-subnets [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-multi-az-subnets.svg)](https://github.com/cloudposse/terraform-aws-multi-az-subnets/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)
<!-- markdownlint-restore -->

[![README Header][readme_header_img]][readme_header_link]

[![Cloud Posse][logo]](https://cpco.io/homepage)

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

Terraform module for multi-AZ [`subnets`](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Subnets.html) provisioning.

The module creates private and public subnets in the provided Availability Zones.

The public subnets are routed to the Internet Gateway specified by `var.igw_id`.

`nat_gateway_enabled` flag controls the creation of NAT Gateways in the public subnets.

The private subnets are routed to the NAT Gateways provided in the `var.az_ngw_ids` map.

If you are creating subnets inside a VPC, consider using [cloudposse/terraform-aws-dynamic-subnets](https://github.com/cloudposse/terraform-aws-dynamic-subnets) instead.

---

This project is part of our comprehensive ["SweetOps"](https://cpco.io/sweetops) approach towards DevOps.
[<img align="right" title="Share via Email" src="https://docs.cloudposse.com/images/ionicons/ios-email-outline-2.0.1-16x16-999999.svg"/>][share_email]
[<img align="right" title="Share on Google+" src="https://docs.cloudposse.com/images/ionicons/social-googleplus-outline-2.0.1-16x16-999999.svg" />][share_googleplus]
[<img align="right" title="Share on Facebook" src="https://docs.cloudposse.com/images/ionicons/social-facebook-outline-2.0.1-16x16-999999.svg" />][share_facebook]
[<img align="right" title="Share on Reddit" src="https://docs.cloudposse.com/images/ionicons/social-reddit-outline-2.0.1-16x16-999999.svg" />][share_reddit]
[<img align="right" title="Share on LinkedIn" src="https://docs.cloudposse.com/images/ionicons/social-linkedin-outline-2.0.1-16x16-999999.svg" />][share_linkedin]
[<img align="right" title="Share on Twitter" src="https://docs.cloudposse.com/images/ionicons/social-twitter-outline-2.0.1-16x16-999999.svg" />][share_twitter]


[![Terraform Open Source Modules](https://docs.cloudposse.com/images/terraform-open-source-modules.svg)][terraform_modules]



It's 100% Open Source and licensed under the [APACHE2](LICENSE).







We literally have [*hundreds of terraform modules*][terraform_modules] that are Open Source and well-maintained. Check them out!



## Screenshots


![terraform-aws-multi-az-subnets](images/terraform-aws-multi-az-subnets.png)
*Example of `terraform apply` outputs*



## Security & Compliance [<img src="https://cloudposse.com/wp-content/uploads/2020/11/bridgecrew.svg" width="250" align="right" />](https://bridgecrew.io/)

Security scanning is graciously provided by Bridgecrew. Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

| Benchmark | Description |
|--------|---------------|
| [![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=INFRASTRUCTURE+SECURITY) | Infrastructure Security Compliance |
| [![CIS KUBERNETES](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/cis_kubernetes)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=CIS+KUBERNETES+V1.5) | Center for Internet Security, KUBERNETES Compliance |
| [![CIS AWS](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=CIS+AWS+V1.2) | Center for Internet Security, AWS Compliance |
| [![CIS AZURE](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/cis_azure)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=CIS+AZURE+V1.1) | Center for Internet Security, AZURE Compliance |
| [![PCI-DSS](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/pci)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=PCI-DSS+V3.2) | Payment Card Industry Data Security Standards Compliance |
| [![NIST-800-53](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=NIST-800-53) | National Institute of Standards and Technology Compliance |
| [![ISO27001](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=ISO27001) | Information Security Management System, ISO/IEC 27001 Compliance |
| [![SOC2](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=SOC2)| Service Organization Control 2 Compliance |
| [![CIS GCP](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/cis_gcp)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=CIS+GCP+V1.1) | Center for Internet Security, GCP Compliance |
| [![HIPAA](https://www.bridgecrew.cloud/badges/github/cloudposse/terraform-aws-multi-az-subnets/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=cloudposse%2Fterraform-aws-multi-az-subnets&benchmark=HIPAA) | Health Insurance Portability and Accountability Compliance |



## Usage


**IMPORTANT:** We do not pin modules to versions in our examples because of the
difficulty of keeping the versions in the documentation in sync with the latest released versions.
We highly recommend that in your code you pin the version to the exact version you are
using so that your infrastructure remains stable, and update versions in a
systematic way so that they do not catch you by surprise.

Also, because of a bug in the Terraform registry ([hashicorp/terraform#21417](https://github.com/hashicorp/terraform/issues/21417)),
the registry shows many of our inputs as required when in fact they are optional.
The table below correctly indicates which inputs are required.


```hcl
locals {
  public_cidr_block  = cidrsubnet(var.cidr_block, 1, 0)
  private_cidr_block = cidrsubnet(var.cidr_block, 1, 1)
}

module "vpc" {
  source = "cloudposse/vpc/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = var.cidr_block
}

module "public_subnets" {
  source = "cloudposse/multi-az-subnets/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace           = var.namespace
  stage               = var.stage
  name                = var.name
  availability_zones  = ["us-east-2a", "us-east-2b", "us-east-2c"]
  vpc_id              = module.vpc.vpc_id
  cidr_block          = local.public_cidr_block
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = "true"
}

module "private_subnets" {
  source = "cloudposse/multi-az-subnets/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace          = var.namespace
  stage              = var.stage
  name               = var.name
  availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
  vpc_id             = module.vpc.vpc_id
  cidr_block         = local.private_cidr_block
  type               = "private"

  az_ngw_ids = module.public_subnets.az_ngw_ids
}
```




## Examples

Given the following configuration

```hcl
module "vpc" {
  source = "cloudposse/vpc/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace  = var.namespace
  name       = "vpc"
  stage      = var.stage
  cidr_block = var.cidr_block
}

locals {
  public_cidr_block  = cidrsubnet(module.vpc.vpc_cidr_block, 1, 0)
  private_cidr_block = cidrsubnet(module.vpc.vpc_cidr_block, 1, 1)
}

module "public_subnets" {
  source = "cloudposse/multi-az-subnets/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace           = var.namespace
  stage               = var.stage
  name                = var.name
  availability_zones  = ["us-east-2a", "us-east-2b", "us-east-2c"]
  vpc_id              = module.vpc.vpc_id
  cidr_block          = local.public_cidr_block
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = "true"
}

module "private_subnets" {
  source = "cloudposse/multi-az-subnets/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace           = var.namespace
  stage               = var.stage
  name                = var.name
  availability_zones  = ["us-east-2a", "us-east-2b", "us-east-2c"]
  vpc_id              = module.vpc.vpc_id
  cidr_block          = local.private_cidr_block
  type                = "private"
  az_ngw_ids          = module.public_subnets.az_ngw_ids
}

output "private_az_subnet_ids" {
  value = module.private_subnets.az_subnet_ids
}

output "public_az_subnet_ids" {
  value = module.public_subnets.az_subnet_ids
}
```

the output Maps of AZ names to subnet IDs look like these

```hcl
public_az_subnet_ids = {
  us-east-2a = subnet-ea58d78e
  us-east-2b = subnet-556ee131
  us-east-2c = subnet-6f54db0b
}
private_az_subnet_ids = {
  us-east-2a = subnet-376de253
  us-east-2b = subnet-9e53dcfa
  us-east-2c = subnet-a86fe0cc
}
```

and the created subnet IDs could be found by the AZ names using `map["key"]` or [`lookup(map, key, [default])`](https://www.terraform.io/docs/configuration/interpolation.html#lookup-map-key-default-),

for example:

`public_az_subnet_ids["us-east-2a"]`

`lookup(private_az_subnet_ids, "us-east-2b")`
<br/>



<!-- markdownlint-disable -->
## Makefile Targets
```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_label"></a> [private\_label](#module\_private\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_public_label"></a> [public\_label](#module\_public\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
| <a name="module_utils"></a> [utils](#module\_utils) | cloudposse/utils/aws | 0.8.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_route.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_availability_zone_attribute_style"></a> [availability\_zone\_attribute\_style](#input\_availability\_zone\_attribute\_style) | The style of Availability Zone code to use in tags and names. One of `full`, `short`, or `fixed`. | `string` | `"full"` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`) | `list(string)` | n/a | yes |
| <a name="input_az_ngw_ids"></a> [az\_ngw\_ids](#input\_az\_ngw\_ids) | Only for private subnets. Map of AZ names to NAT Gateway IDs that are used as default routes when creating private subnets.<br>You should either supply one NAT Gateway ID for each AZ in `var.availability_zones` or leave the map empty.<br>If empty, no default egress route will be created and you will have to create your own using `aws_route`. | `map(string)` | `{}` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`) | `string` | n/a | yes |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_igw_id"></a> [igw\_id](#input\_igw\_id) | Internet Gateway ID that is used as a default route when creating public subnets (e.g. `igw-9c26a123`) | `string` | `""` | no |
| <a name="input_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#input\_ipv6\_cidr\_block) | Base IPv6 CIDR block which is divided into /64 subnet CIDR blocks | `string` | `null` | no |
| <a name="input_ipv6_enabled"></a> [ipv6\_enabled](#input\_ipv6\_enabled) | Flag to enable/disable IPv6 creation in public subnets | `bool` | `false` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_max_subnets"></a> [max\_subnets](#input\_max\_subnets) | Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation | `string` | `"6"` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_nat_gateway_enabled"></a> [nat\_gateway\_enabled](#input\_nat\_gateway\_enabled) | Flag to enable/disable NAT Gateways creation in public subnets | `string` | `"true"` | no |
| <a name="input_private_network_acl_egress"></a> [private\_network\_acl\_egress](#input\_private\_network\_acl\_egress) | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_private_network_acl_id"></a> [private\_network\_acl\_id](#input\_private\_network\_acl\_id) | Network ACL ID that is added to the private subnets. If empty, a new ACL will be created | `string` | `""` | no |
| <a name="input_private_network_acl_ingress"></a> [private\_network\_acl\_ingress](#input\_private\_network\_acl\_ingress) | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_public_network_acl_egress"></a> [public\_network\_acl\_egress](#input\_public\_network\_acl\_egress) | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_public_network_acl_id"></a> [public\_network\_acl\_id](#input\_public\_network\_acl\_id) | Network ACL ID that is added to the public subnets. If empty, a new ACL will be created | `string` | `""` | no |
| <a name="input_public_network_acl_ingress"></a> [public\_network\_acl\_ingress](#input\_public\_network\_acl\_ingress) | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_type"></a> [type](#input\_type) | Type of subnets to create (`private` or `public`) | `string` | `"private"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_az_ngw_ids"></a> [az\_ngw\_ids](#output\_az\_ngw\_ids) | Map of AZ names to NAT Gateway IDs (only for public subnets) |
| <a name="output_az_route_table_ids"></a> [az\_route\_table\_ids](#output\_az\_route\_table\_ids) | Map of AZ names to Route Table IDs |
| <a name="output_az_subnet_arns"></a> [az\_subnet\_arns](#output\_az\_subnet\_arns) | Map of AZ names to subnet ARNs |
| <a name="output_az_subnet_cidr_blocks"></a> [az\_subnet\_cidr\_blocks](#output\_az\_subnet\_cidr\_blocks) | Map of AZ names to subnet CIDR blocks |
| <a name="output_az_subnet_ids"></a> [az\_subnet\_ids](#output\_az\_subnet\_ids) | Map of AZ names to subnet IDs |
| <a name="output_az_subnet_ipv6_cidr_blocks"></a> [az\_subnet\_ipv6\_cidr\_blocks](#output\_az\_subnet\_ipv6\_cidr\_blocks) | Map of AZ names to subnet IPv6 CIDR blocks |
| <a name="output_az_subnet_map"></a> [az\_subnet\_map](#output\_az\_subnet\_map) | Map of AZ names to map of information about subnets |
<!-- markdownlint-restore -->



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

**Got a question?** We got answers.

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-multi-az-subnets/issues), send us an [email][email] or join our [Slack Community][slack].

[![README Commercial Support][readme_commercial_support_img]][readme_commercial_support_link]

## DevOps Accelerator for Startups


We are a [**DevOps Accelerator**][commercial_support]. We'll help you build your cloud infrastructure from the ground up so you can own it. Then we'll show you how to operate it and stick around for as long as you need us.

[![Learn More](https://img.shields.io/badge/learn%20more-success.svg?style=for-the-badge)][commercial_support]

Work directly with our team of DevOps experts via email, slack, and video conferencing.

We deliver 10x the value for a fraction of the cost of a full-time engineer. Our track record is not even funny. If you want things done right and you need it done FAST, then we're your best bet.

- **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
- **Release Engineering.** You'll have end-to-end CI/CD with unlimited staging environments.
- **Site Reliability Engineering.** You'll have total visibility into your apps and microservices.
- **Security Baseline.** You'll have built-in governance with accountability and audit logs for all changes.
- **GitOps.** You'll be able to operate your infrastructure via Pull Requests.
- **Training.** You'll receive hands-on training so your team can operate what we build.
- **Questions.** You'll have a direct line of communication between our teams via a Shared Slack channel.
- **Troubleshooting.** You'll get help to triage when things aren't working.
- **Code Reviews.** You'll receive constructive feedback on Pull Requests.
- **Bug Fixes.** We'll rapidly work with you to fix any bugs in our projects.

## Slack Community

Join our [Open Source Community][slack] on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

## Discourse Forums

Participate in our [Discourse Forums][discourse]. Here you'll find answers to commonly asked questions. Most questions will be related to the enormous number of projects we support on our GitHub. Come here to collaborate on answers, find solutions, and get ideas about the products and services we value. It only takes a minute to get started! Just sign in with SSO using your GitHub account.

## Newsletter

Sign up for [our newsletter][newsletter] that covers everything on our technology radar.  Receive updates on what we're up to on GitHub as well as awesome new projects we discover.

## Office Hours

[Join us every Wednesday via Zoom][office_hours] for our weekly "Lunch & Learn" sessions. It's **FREE** for everyone!

[![zoom](https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png")][office_hours]

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

Copyright © 2017-2022 [Cloud Posse, LLC](https://cpco.io/copyright)



## License

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

```text
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
```









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know by [leaving a testimonial][testimonial]!

[![Cloud Posse][logo]][website]

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We ❤️  [Open Source Software][we_love_open_source].

We offer [paid support][commercial_support] on all of our projects.

Check out [our other projects][github], [follow us on twitter][twitter], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.



### Contributors

<!-- markdownlint-disable -->
|  [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Maxim Mironenko][maximmi_avatar]][maximmi_homepage]<br/>[Maxim Mironenko][maximmi_homepage] |
|---|---|
<!-- markdownlint-restore -->

  [aknysh_homepage]: https://github.com/aknysh
  [aknysh_avatar]: https://img.cloudposse.com/150x150/https://github.com/aknysh.png
  [maximmi_homepage]: https://github.com/maximmi
  [maximmi_avatar]: https://img.cloudposse.com/150x150/https://github.com/maximmi.png

[![README Footer][readme_footer_img]][readme_footer_link]
[![Beacon][beacon]][website]

  [logo]: https://cloudposse.com/logo-300x69.svg
  [docs]: https://cpco.io/docs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=docs
  [website]: https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=website
  [github]: https://cpco.io/github?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=github
  [jobs]: https://cpco.io/jobs?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=jobs
  [hire]: https://cpco.io/hire?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=hire
  [slack]: https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=slack
  [linkedin]: https://cpco.io/linkedin?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=linkedin
  [twitter]: https://cpco.io/twitter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=twitter
  [testimonial]: https://cpco.io/leave-testimonial?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=testimonial
  [office_hours]: https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=office_hours
  [newsletter]: https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=newsletter
  [discourse]: https://ask.sweetops.com/?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=discourse
  [email]: https://cpco.io/email?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=email
  [commercial_support]: https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=commercial_support
  [we_love_open_source]: https://cpco.io/we-love-open-source?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=we_love_open_source
  [terraform_modules]: https://cpco.io/terraform-modules?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=terraform_modules
  [readme_header_img]: https://cloudposse.com/readme/header/img
  [readme_header_link]: https://cloudposse.com/readme/header/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=readme_header_link
  [readme_footer_img]: https://cloudposse.com/readme/footer/img
  [readme_footer_link]: https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=readme_footer_link
  [readme_commercial_support_img]: https://cloudposse.com/readme/commercial-support/img
  [readme_commercial_support_link]: https://cloudposse.com/readme/commercial-support/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-multi-az-subnets&utm_content=readme_commercial_support_link
  [share_twitter]: https://twitter.com/intent/tweet/?text=terraform-aws-multi-az-subnets&url=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_linkedin]: https://www.linkedin.com/shareArticle?mini=true&title=terraform-aws-multi-az-subnets&url=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_reddit]: https://reddit.com/submit/?url=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_facebook]: https://facebook.com/sharer/sharer.php?u=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_googleplus]: https://plus.google.com/share?url=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [share_email]: mailto:?subject=terraform-aws-multi-az-subnets&body=https://github.com/cloudposse/terraform-aws-multi-az-subnets
  [beacon]: https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-multi-az-subnets?pixel&cs=github&cm=readme&an=terraform-aws-multi-az-subnets
