######################################################################
# Config Provider
######################################################################

# Require Huawei cloud provider
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">=1.44.0"
    }
  }
}

######################################################################
# VPN
######################################################################

# Create BKK VPN gateway
resource "huaweicloud_vpn_gateway" "bkk" {
  name               = var.bkk_name
  vpc_id             = var.bkk_vpc_id
  local_subnets      = ["172.16.0.0/24","192.168.0.0/24"]
  connect_subnet     = "172.16.3.0/24"
  availability_zones = ["ap-southeast-2a", "ap-southeast-2c"]

  master_eip {
    bandwidth_name = "bkk1"
    type           = "5_bgp"
    bandwidth_size = 5
    charge_mode    = "traffic"
  }

  slave_eip {
    bandwidth_name = "bkk2"
    type           = "5_bgp"
    bandwidth_size = 5
    charge_mode    = "traffic"
  }
}

# Create BKK customer gateway
resource "huaweicloud_vpn_customer_gateway" "bkk" {
  name   = "hk_ip"
  ip     = huaweicloud_vpn_gateway.hk.master_eip[0].ip_address
  region = "ap-southeast-2"
}

# Create BKK vpn conneciton
resource "huaweicloud_vpn_connection" "bkk" {
  name                = "bkk_to_hk"
  gateway_id          = huaweicloud_vpn_gateway.bkk.id
  gateway_ip          = huaweicloud_vpn_gateway.bkk.master_eip[0].id
  customer_gateway_id = huaweicloud_vpn_customer_gateway.bkk.id
  peer_subnets        = huaweicloud_vpn_gateway.hk.local_subnets
  vpn_type            = "static"
  psk                 = "P@ssw0rdHCIE0lab999"
}

######################################################################

# Create HK VPN Gateway
resource "huaweicloud_vpn_gateway" "hk" {
  region             = "ap-southeast-1"
  name               = var.hk_name
  vpc_id             = var.hk_vpc_id
  local_subnets      = ["192.168.1.0/24","172.16.1.0/24"]
  connect_subnet     = "192.168.3.0/24"
  availability_zones = ["ap-southeast-1b", "ap-southeast-1c"]

  master_eip {
    bandwidth_name = "hk1"
    type           = "5_bgp"
    bandwidth_size = 5
    charge_mode    = "traffic"
  }

  slave_eip {
    bandwidth_name = "hk2"
    type           = "5_bgp"
    bandwidth_size = 5
    charge_mode    = "traffic"
  }
}

# Create HK customer gateway
resource "huaweicloud_vpn_customer_gateway" "hk" {
  name   = "bkk_ip"
  ip     = huaweicloud_vpn_gateway.bkk.master_eip[0].ip_address
  region = "ap-southeast-1"
}

# Create HK vpn conneciton
resource "huaweicloud_vpn_connection" "hk" {
  region              = "ap-southeast-1"
  name                = "hk_to_bkk"
  gateway_id          = huaweicloud_vpn_gateway.hk.id
  gateway_ip          = huaweicloud_vpn_gateway.hk.master_eip[0].id
  customer_gateway_id = huaweicloud_vpn_customer_gateway.hk.id
  peer_subnets        = huaweicloud_vpn_gateway.bkk.local_subnets
  vpn_type            = "static"
  psk                 = "P@ssw0rdHCIE0lab999"
}
