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
  default     = []
  description = "Only for public subnets. List of Availability Zones to create public subnets (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
}

variable "max_subnets" {
  default     = "16"
  description = "Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation"
}

variable "type" {
  type        = "string"
  default     = "private"
  description = "Type of subnets to create (`private` or `public`)"
}

variable "vpc_id" {
  type        = "string"
  description = "VPC ID"
}

variable "cidr_block" {
  type        = "string"
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "igw_id" {
  type        = "string"
  description = "Only for public subnets. Internet Gateway ID which is used as a default route in public route tables when creating public subnets (e.g. `igw-9c26a123`)"
  default     = ""
}

variable "az_ngw_ids" {
  type        = "map"
  description = "Only for private subnets. Map of AZ names to NAT Gateway IDs which are used as default routes in private route tables when creating private subnets"
  default     = {}
}

variable "public_network_acl_id" {
  type        = "string"
  description = "Network ACL ID that is added to the public subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "private_network_acl_id" {
  type        = "string"
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
  description = "Flag to enable/disable NAT Gateways for public subnets, and to enable/disable routing to NAT Gateways for private subnets"
  default     = "true"
}
