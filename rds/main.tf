######################################################################
# Provider
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
# RDS
######################################################################

# Create EIP for RDS
resource "huaweicloud_vpc_eip" "myeip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "forRDS"
    size        = 5
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

#get the port of rds instance by private_ip
data "huaweicloud_networking_port" "rds_port" {
  network_id = var.bkk_subnet_id
  fixed_ip   = huaweicloud_rds_instance.bkk_rds_instance.private_ips[0]
}

# resource "huaweicloud_networking_port" "rds_port" {
#   network_id = huaweicloud_rds_instance.bkk_rds_instance.subnet_id
#   fixed_ip   = huaweicloud_rds_instance.bkk_rds_instance.private_ips[0]
# }

resource "huaweicloud_vpc_eip_associate" "associated" {
  public_ip = huaweicloud_vpc_eip.myeip.address
  port_id   = data.huaweicloud_networking_port.rds_port.id
}

# Create BKK RDS instance
resource "huaweicloud_rds_instance" "bkk_rds_instance" {
  name                = var.rds.bkk_name
  flavor              = "rds.mysql.n1.large.2.ha"
  ha_replication_mode = "async"
  vpc_id              = var.bkk_vpc_id
  subnet_id           = var.bkk_subnet_id
  security_group_id   = var.bkk_security_group_id
  availability_zone = [
    "ap-southeast-2a",
    "ap-southeast-2b"
  ]

  db {
    type     = "Mysql"
    version  = "5.7"
    port     = var.rds.bkk_port
    password = var.rds.bkk_password
  }
  volume {
    type = "CLOUDSSD"
    size = 100
  }
  backup_strategy {
    start_time = "01:00-02:00"
    keep_days  = 3
  }
}

# Create BKK database
resource "huaweicloud_rds_database" "wordpress_database_bkk" {
  description   = "wordpress database creation"
  name          = var.rds.bkk_name
  instance_id   = huaweicloud_rds_instance.bkk_rds_instance.id
  character_set = "utf8"
}

######################################################################

# Create HK RDS instance
resource "huaweicloud_rds_instance" "hk_rds_instance" {
  region              = "ap-southeast-1"
  name                = var.rds.hk_name
  flavor              = "rds.mysql.n1.large.2.ha"
  ha_replication_mode = "async"
  vpc_id              = var.hk_vpc_id
  subnet_id           = var.hk_subnet_id
  security_group_id   = var.hk_security_group_id
  availability_zone = [
    "ap-southeast-1a",
    "ap-southeast-1b"
  ]

  db {
    type     = "Mysql"
    version  = "5.7"
    port     = var.rds.hk_port
    password = var.rds.hk_password
  }
  volume {
    type = "CLOUDSSD"
    size = 100
  }
  backup_strategy {
    start_time = "01:00-02:00"
    keep_days  = 3
  }
}
