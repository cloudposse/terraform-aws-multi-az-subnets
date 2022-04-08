variable "region" {
  type = string
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones (e.g. `['us-east-1a', 'us-east-1b', 'us-east-1c']`)"
}

variable "ipv6_enabled" {
  description = "Flag to enable/disable IPv6 creation in public subnets"
  type        = bool
}
