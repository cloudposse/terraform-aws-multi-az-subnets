variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
}

variable "max_subnets" {
  default     = "6"
  description = "Maximum number of subnets that can be created. The variable is used for CIDR blocks calculation"
}

variable "type" {
  type        = string
  default     = "private"
  description = "Type of subnets to create (`private` or `public`)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "cidr_block" {
  type        = string
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "igw_id" {
  type        = string
  description = "Internet Gateway ID that is used as a default route when creating public subnets (e.g. `igw-9c26a123`)"
  default     = ""
}

variable "az_ngw_ids" {
  type        = map(string)
  description = <<-EOT
    Only for private subnets. Map of AZ names to NAT Gateway IDs that are used as default routes when creating private subnets.
    You should either supply one NAT Gateway ID for each AZ in `var.availability_zones` or leave the map empty.
    If empty, no default egress route will be created and you will have to create your own using `aws_route`.
    EOT
  default     = {}
}

variable "public_network_acl_id" {
  type        = string
  description = "Network ACL ID that is added to the public subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "private_network_acl_id" {
  type        = string
  description = "Network ACL ID that is added to the private subnets. If empty, a new ACL will be created"
  default     = ""
}

variable "public_network_acl_egress" {
  description = "Egress network ACL rules"
  type        = list(map(string))

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
  type        = list(map(string))

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
  type        = list(map(string))

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
  type        = list(map(string))

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

variable "nat_gateway_enabled" {
  description = "Flag to enable/disable NAT Gateways creation in public subnets"
  default     = "true"
}

variable "ipv6_enabled" {
  description = "Flag to enable/disable IPv6 creation in public subnets"
  type        = bool
  default     = false
}

variable "ipv6_cidr_block" {
  type        = string
  description = "Base IPv6 CIDR block which is divided into /64 subnet CIDR blocks"
  default     = null
}
