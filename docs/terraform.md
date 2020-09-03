<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 2.0 |
| local | >= 1.2 |
| null | >= 2.0 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (e.g. `policy` or `role`) | `list(string)` | `[]` | no |
| availability\_zones | List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`) | `list(string)` | n/a | yes |
| az\_ngw\_ids | Only for private subnets. Map of AZ names to NAT Gateway IDs that are used as default routes when creating private subnets | `map(string)` | `{}` | no |
| cidr\_block | Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`) | `string` | n/a | yes |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| enabled | Set to false to prevent the module from creating any resources | `string` | `"true"` | no |
| igw\_id | Internet Gateway ID that is used as a default route when creating public subnets (e.g. `igw-9c26a123`) | `string` | `""` | no |
| max\_subnets | Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation | `string` | `"6"` | no |
| name | Application or solution name | `string` | n/a | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | `string` | n/a | yes |
| nat\_gateway\_enabled | Flag to enable/disable NAT Gateways creation in public subnets | `string` | `"true"` | no |
| private\_network\_acl\_egress | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| private\_network\_acl\_id | Network ACL ID that is added to the private subnets. If empty, a new ACL will be created | `string` | `""` | no |
| private\_network\_acl\_ingress | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_network\_acl\_egress | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_network\_acl\_id | Network ACL ID that is added to the public subnets. If empty, a new ACL will be created | `string` | `""` | no |
| public\_network\_acl\_ingress | Egress network ACL rules | `list(map(string))` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |
| type | Type of subnets to create (`private` or `public`) | `string` | `"private"` | no |
| vpc\_id | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| az\_ngw\_ids | Map of AZ names to NAT Gateway IDs (only for public subnets) |
| az\_route\_table\_ids | Map of AZ names to Route Table IDs |
| az\_subnet\_arns | Map of AZ names to subnet ARNs |
| az\_subnet\_ids | Map of AZ names to subnet IDs |

<!-- markdownlint-restore -->
