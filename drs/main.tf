######################################################################
# Config Provider
######################################################################

# Require Huawei cloud provider
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
# DRS
######################################################################

resource "huaweicloud_drs_job" "drs" {
  region         = "ap-southeast-1"
  name           = var.name
  type           = "migration"
  engine_type    = "mysql"
  direction      = "up"
  net_type       = "eip"
  migration_type = "FULL_INCR_TRANS"
  description    = "DRS"
  force_destroy  = true

  source_db {
    engine_type = "mysql"
    ip          = var.source_ip
    port        = var.source_port
    user        = var.source_user
    password    = var.source_password
    ssl_enabled = false
  }

  destination_db {
    region      = "ap-southeast-1"
    ip          = var.destination_ip
    port        = 3310
    engine_type = "mysql"
    user        = "root"
    password    = var.destination_password
    instance_id = var.destination_instance_id
    subnet_id   = var.destination_instance_subnet_id

  }

  lifecycle {
    ignore_changes = [
      source_db.0.password, destination_db.0.password,
    ]
  }

}
