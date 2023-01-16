######################################################################
# Provider
######################################################################
terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">=1.40.0"
    }
  }
}

######################################################################
# SG of BKK and HK
######################################################################

resource "huaweicloud_networking_secgroup" "bkk_sg_web" {
  name   = var.sg.bkk_sg_web_name
  region = "ap-southeast-2"
}

resource "huaweicloud_networking_secgroup" "hk_sg_web" {
  name   = var.sg.hk_sg_web_name
  region = "ap-southeast-1"
}

resource "huaweicloud_networking_secgroup" "bkk_sg_db" {
  name   = var.sg.bkk_sg_db_name
  region = "ap-southeast-2"
}

resource "huaweicloud_networking_secgroup" "hk_sg_db" {
  name   = var.sg.hk_sg_db_name
  region = "ap-southeast-1"
}

######################################################################
# SG rule of BKK
######################################################################

# Allow web ping
resource "huaweicloud_networking_secgroup_rule" "bkk_allow_web_ping" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.bkk_sg_web.id

}

# Allow web https
resource "huaweicloud_networking_secgroup_rule" "bkk_allow_web_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.bkk_sg_web.id
}

# Allow db ping
resource "huaweicloud_networking_secgroup_rule" "bkk_allow_db_ping" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.bkk_sg_db.id

}

# Allow db https
resource "huaweicloud_networking_secgroup_rule" "bkk_allow_db_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3310
  port_range_max    = 3310
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.bkk_sg_db.id
}

resource "huaweicloud_networking_secgroup_rule" "allow_redis_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6379
  port_range_max    = 6379
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.bkk_sg_db.id
}

######################################################################
# SG rule of HK
######################################################################

# Allow web ping
resource "huaweicloud_networking_secgroup_rule" "hk_allow_web_ping" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.hk_sg_web.id
  region            = "ap-southeast-1"
}

# Allow web https
resource "huaweicloud_networking_secgroup_rule" "hk_allow_web_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.hk_sg_web.id
  region            = "ap-southeast-1"
}

# Allow db ping
resource "huaweicloud_networking_secgroup_rule" "hk_allow_db_ping" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.hk_sg_db.id
  region            = "ap-southeast-1"
}

# Allow db https
resource "huaweicloud_networking_secgroup_rule" "hk_allow_db_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3310
  port_range_max    = 3310
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = huaweicloud_networking_secgroup.hk_sg_db.id
  region            = "ap-southeast-1"
}
