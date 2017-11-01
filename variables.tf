variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  type        = "string"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = "string"
}

variable "name" {
  type        = "string"
  description = "Application or solution name"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "availability_zones" {
  type        = "list"
  description = "List of AZ names (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
}

variable "max_subnets" {
  default     = "16"
  description = "Maximum number of subnets which can be created. This variable is being used for CIDR blocks calculation. Default to length of `names` argument"
}

variable "type" {
  default     = "private"
  description = "Type of subnets to create (`private` or `public`)"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "cidr_block" {
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "igw_id" {
  description = "Internet Gateway ID which is used as a default route in public route tables when creating public subnets (e.g. `igw-9c26a123`)"
  default     = ""
}

variable "ngw_ids" {
  type        = "list"
  description = "NAT Gateway IDs which are used as default routes in private route tables when creating private subnets (e.g. [`ngw-9c26a123`, `ngw-3b45a533`])"
  default     = []
}

variable "public_network_acl_id" {
  description = "Network ACL ID that is added to the public subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "private_network_acl_id" {
  description = "Network ACL ID that is added to the private subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "public_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "public_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "private_network_acl_ingress" {
  description = "Egress network ACL rules"
  type        = "list"

  default = [
    {
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
    },
  ]
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "nat_gateway_enabled" {
  description = "Flag to enable/disable NAT gateways when creating public subnets"
  default     = "true"
}
