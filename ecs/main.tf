######################################################################
# ECS
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

# Get flavors list
data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = "ap-southeast-2a"
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

# Create BKK network test ECSs
resource "huaweicloud_compute_instance" "connection_test_web_bkk" {
  name            = var.connection_ecs_name_bkk.ecs_web_name_bkk
  image_id        = "6b33903d-c3ef-4d00-bf9d-9535cb9dd42f"
  flavor_id       = data.huaweicloud_compute_flavors.myflavor.ids[0]
  security_groups = ["sg_web"]
  admin_pass      = "P@ssw0rdHCIE0lab999"

  network {
    uuid = var.ecs_web_uuid_bkk
  }
}

resource "huaweicloud_compute_instance" "connection_test_db_bkk" {
  name            = var.connection_ecs_name_bkk.ecs_db_name_bkk
  image_id        = "6b33903d-c3ef-4d00-bf9d-9535cb9dd42f"
  flavor_id       = data.huaweicloud_compute_flavors.myflavor.ids[0]
  security_groups = ["sg_db"]
  admin_pass      = "P@ssw0rdHCIE0lab999"

  network {
    uuid = var.ecs_db_uuid_bkk
  }
}

# Create HK network test ECSs
resource "huaweicloud_compute_instance" "connection_test_web_hk" {
  region          = "ap-southeast-1"
  name            = var.connection_ecs_name_hk.ecs_web_name_hk
  image_id        = "5be19e6d-80ef-4e9d-96a2-ec1b8438065d"
  flavor_id       = data.huaweicloud_compute_flavors.myflavor.ids[0]
  security_groups = ["sg_web"]
  admin_pass      = "P@ssw0rdHCIE0lab999"

  network {
    uuid = var.ecs_web_uuid_hk
  }
}


resource "huaweicloud_compute_instance" "connection_test_db_hk" {
  region          = "ap-southeast-1"
  name            = var.connection_ecs_name_hk.ecs_db_name_hk
  image_id        = "5be19e6d-80ef-4e9d-96a2-ec1b8438065d"
  flavor_id       = data.huaweicloud_compute_flavors.myflavor.ids[0]
  security_groups = ["sg_db"]
  admin_pass      = "P@ssw0rdHCIE0lab999"

  network {
    uuid = var.ecs_db_uuid_hk
  }
}

######################################################################

# Create ECS which has Wordpres installed
# resource "huaweicloud_compute_instance" "wordpress_installed" {
#   name            = var.ecs_name
#   image_id        = "69168713-9c4e-4579-9a9d-291f7ce7ab0b"
#   flavor_id       = data.huaweicloud_compute_flavors.myflavor.ids[0]
#   security_groups = ["sg_web"]

#   network {
#     uuid = var.ecs_uuid
#   }
# }

# Create EIP
resource "huaweicloud_vpc_eip" "ecs_eip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "mybandwidth"
    size        = 8
    share_type  = "PER"
    charge_mode = "traffic"
  }
}

# Associate ECS with EIP
# resource "huaweicloud_compute_eip_associate" "associated" {
#   public_ip   = huaweicloud_vpc_eip.ecs_eip.address
#   instance_id = huaweicloud_compute_instance.wordpress_installed.id
# }


