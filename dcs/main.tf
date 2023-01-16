######################################################################
# DCS
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

# Create DCS 
data "huaweicloud_dcs_flavors" "master_standby_flavors" {
  cache_mode = "ha"
  capacity   = 0.125
}

resource "huaweicloud_dcs_instance" "dcs_wordpress" {
  engine         = "redis"
  name           = "wordpress"
  engine_version = "5.0"
  private_ip     = "172.16.0.199"
  capacity       = data.huaweicloud_dcs_flavors.master_standby_flavors.capacity
  flavor         = data.huaweicloud_dcs_flavors.master_standby_flavors.flavors[0].name

  availability_zones = [
    "ap-southeast-2a",
    "ap-southeast-2b"
  ]
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id
  password  = "P@ssw0rdHCIE0lab999"
}
