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
| az_subnet_arns | Map of AZ names to subnet ARNs |
| az_subnet_ids | Map of AZ names to subnet IDs |

