region = "eu-west-1"

namespace = "eg"

stage = "test"

name = "multi-az-subnets-no-nat"

availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

cidr_block = "172.16.0.0/20"

nat_gateway_enabled = false