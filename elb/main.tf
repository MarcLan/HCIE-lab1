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
# ELB
######################################################################

# BKK ELB
resource "huaweicloud_lb_loadbalancer" "lb_bkk" {
  name          = var.bkk_name
  vip_subnet_id = var.bkk_ipv4_subnet_id
}

# BKK Listener
resource "huaweicloud_lb_listener" "listener_bkk" {
  protocol        = "HTTP"
  protocol_port   = 8080
  loadbalancer_id = huaweicloud_lb_loadbalancer.lb_bkk.id
}

# BKK Backend group
resource "huaweicloud_lb_pool" "pool_bkk" {
  protocol    = "HTTP"
  lb_method   = "LEAST_CONNECTIONS"
  listener_id = huaweicloud_lb_listener.listener_bkk.id
}

######################################################################

# HK ELB
resource "huaweicloud_lb_loadbalancer" "lb_hk" {
  name          = var.hk_name
  vip_subnet_id = var.hk_ipv4_subnet_id
  region        = "ap-southeast-1"
}

# HK Listener
resource "huaweicloud_lb_listener" "listener_hk" {
  region          = "ap-southeast-1"
  protocol        = "HTTP"
  protocol_port   = 8080
  loadbalancer_id = huaweicloud_lb_loadbalancer.lb_hk.id
}

# HK Backend group
resource "huaweicloud_lb_pool" "pool_hk" {
  region      = "ap-southeast-1"
  protocol    = "HTTP"
  lb_method   = "LEAST_CONNECTIONS"
  listener_id = huaweicloud_lb_listener.listener_hk.id
}
