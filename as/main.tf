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
# AS
######################################################################

resource "huaweicloud_as_group" "my_as_group_with_enhanced_lb" {
  scaling_group_name       = var.name
  scaling_configuration_id = var.configuration_id
  desire_instance_number   = 1
  min_instance_number      = 1
  max_instance_number      = 3
  vpc_id                   = var.vpc_id

  networks {
    id = var.subnet_id
  }

  security_groups {
    id = var.security_group_id
  }
}


#   lbaas_listeners {
#     pool_id       = huaweicloud_lb_pool.pool_1.id
#     protocol_port = huaweicloud_lb_listener.listener_1.protocol_port
#   }
# }
