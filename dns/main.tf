######################################################################
# Config Provider
######################################################################

terraform {
  required_version = ">=1.3.0"
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">=1.44.0"
    }
  }
}

######################################################################
# DNS
######################################################################

variable "dns_name" {}
variable "router_id" {}

resource "huaweicloud_dns_zone" "zone" {
  name        = var.dns_name
  email       = "admin@admin.com"
  description = "HCIE zone"
  ttl         = 6000
  zone_type   = "private"

  router {
    router_id = var.router_id
  }
}