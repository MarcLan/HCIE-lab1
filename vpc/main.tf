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
# Default VPCs
######################################################################

# VPC BKK web
resource "huaweicloud_vpc" "vpc_web_active" {
  name   = var.vpc.vpc_web_active_name
  cidr   = var.vpc.vpc_web_active_cidr
  region = "ap-southeast-2"
}

# VPC BKK db
resource "huaweicloud_vpc" "vpc_db_active" {
  name   = var.vpc.vpc_db_active_name
  cidr   = var.vpc.vpc_db_active_cidr
  region = "ap-southeast-2"
}

# VPC BKK drill
resource "huaweicloud_vpc" "vpc_drill_active" {
  name   = var.vpc.vpc_drill_active_name
  cidr   = var.vpc.vpc_drill_active_cidr
  region = "ap-southeast-2"
}

# VPC HK web
resource "huaweicloud_vpc" "vpc_web_branch" {
  name   = var.vpc.vpc_web_branch_name
  cidr   = var.vpc.vpc_web_branch_cidr
  region = "ap-southeast-1"
}

# VPC HK db
resource "huaweicloud_vpc" "vpc_db_dr" {
  name   = var.vpc.vpc_db_dr_name
  cidr   = var.vpc.vpc_db_dr_cidr
  region = "ap-southeast-1"
}

# # VPC list
# resource "huaweicloud_vpc" "vpc_list" {
#   count = 2
#   name = var.vpc_list_name[count.index]
#   cidr = var.vpc_list_cidr[count.index]
# }

######################################################################
# Default Subnets
######################################################################

# BKK subnet web
resource "huaweicloud_vpc_subnet" "subnet_web" {
  vpc_id     = huaweicloud_vpc.vpc_web_active.id
  name       = var.vpc.subnet_web_name
  cidr       = var.vpc.subnet_web_cidr
  gateway_ip = "192.168.0.1"
}

# BKK subnet db
resource "huaweicloud_vpc_subnet" "subnet_db" {
  vpc_id     = huaweicloud_vpc.vpc_db_active.id
  name       = var.vpc.subnet_db_name
  cidr       = var.vpc.subnet_db_cidr
  gateway_ip = "172.16.0.1"
}

# BKK subnet drill
resource "huaweicloud_vpc_subnet" "subnet_drill" {
  vpc_id     = huaweicloud_vpc.vpc_drill_active.id
  name       = var.vpc.subnet_drill_name
  cidr       = var.vpc.subnet_drill_cidr
  gateway_ip = "10.0.0.1"
}

# HK subnet web branch
resource "huaweicloud_vpc_subnet" "subnet_web_branch" {
  vpc_id     = huaweicloud_vpc.vpc_web_branch.id
  name       = var.vpc.subnet_web_branch_name
  cidr       = var.vpc.subnet_web_branch_cidr
  gateway_ip = "192.168.1.1"
  region     = "ap-southeast-1"
}

# HK subnet db dr
resource "huaweicloud_vpc_subnet" "subnet_db_dr" {
  vpc_id     = huaweicloud_vpc.vpc_db_dr.id
  name       = var.vpc.subnet_db_dr_name
  cidr       = var.vpc.subnet_db_dr_cidr
  gateway_ip = "172.16.1.1"
  region     = "ap-southeast-1"
}

######################################################################
# VPC Peering
######################################################################

# Create BKK VPC Peering
resource "huaweicloud_vpc_peering_connection" "vpc_pearing_web_db" {
  name        = "web_db"
  vpc_id      = huaweicloud_vpc.vpc_web_active.id
  peer_vpc_id = huaweicloud_vpc.vpc_db_active.id
}

# Create BKK VPC Peering route
resource "huaweicloud_vpc_route" "peering_web_db" {
  vpc_id      = huaweicloud_vpc.vpc_web_active.id
  destination = "172.16.0.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.vpc_pearing_web_db.id
}

resource "huaweicloud_vpc_route" "peering_db_web" {
  vpc_id      = huaweicloud_vpc.vpc_db_active.id
  destination = "192.168.0.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.vpc_pearing_web_db.id
}

resource "huaweicloud_vpc_route" "vpc_vpn_bkk_1" {
  vpc_id      = huaweicloud_vpc.vpc_web_active.id
  destination = "192.168.1.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.vpc_pearing_web_db.id
}

resource "huaweicloud_vpc_route" "vpc_vpn_bkk_2" {
  vpc_id      = huaweicloud_vpc.vpc_web_active.id
  destination = "172.16.1.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.vpc_pearing_web_db.id
}

######################################################################
# Create HK VPC Peering
resource "huaweicloud_vpc_peering_connection" "vpc_pearing_web_db_hk" {
  name        = "web_db"
  vpc_id      = huaweicloud_vpc.vpc_web_branch.id
  peer_vpc_id = huaweicloud_vpc.vpc_db_dr.id
  region      = "ap-southeast-1"
}

# Create HK VPC Peering route
resource "huaweicloud_vpc_route" "peering_web_db_hk" {
  vpc_id      = huaweicloud_vpc.vpc_web_branch.id
  destination = "172.16.1.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.vpc_pearing_web_db_hk.id
  region      = "ap-southeast-1"
}

resource "huaweicloud_vpc_route" "peering_db_web_hk" {
  vpc_id      = huaweicloud_vpc.vpc_db_dr.id
  destination = "192.168.1.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.vpc_pearing_web_db_hk.id
  region      = "ap-southeast-1"
}

resource "huaweicloud_vpc_route" "vpc_vpn_hk_1" {
  vpc_id      = huaweicloud_vpc.vpc_db_dr.id
  destination = "172.16.0.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.vpc_pearing_web_db_hk.id
  region      = "ap-southeast-1"
}

resource "huaweicloud_vpc_route" "vpc_vpn_hk_2" {
  vpc_id      = huaweicloud_vpc.vpc_db_dr.id
  destination = "192.168.0.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.vpc_pearing_web_db_hk.id
  region      = "ap-southeast-1"
}