######################################################################
# Config Provider
######################################################################

# Require Huawei cloud provider
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">=1.40.0"
    }
  }
}

######################################################################
# NAT
######################################################################

resource "huaweicloud_nat_gateway" "nat" {
  name        = var.name
  description = "test for terraform"
  spec        = "3"
  vpc_id      = var.vpc_id
  subnet_id   = var.subnet_id
}
