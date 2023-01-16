variable "subnet_gateway" {
  type = list(string)
  default = [
    "192.168.0.1",
    "172.16.0.1",
    "10.0.0.1"
  ]
}

# variable "vpc" {
#   type = object({
#     web_vpc_name         = string
#     web_vpc_cidr         = string
#     db_vpc_name          = string
#     db_vpc_cidr          = string
#     drill_vpc_name       = string
#     drill_vpc_cidr       = string
#     subnet_web_name      = string
#     subnet_web_cidr      = string
#     subnet_web_gateway   = string
#     subnet_db_gateway    = string
#     subnet_drill_gateway = string
#   })

#   default = {
#     web_vpc_cidr         = "value"
#     web_vpc_name         = "value"
#     db_vpc_cidr          = "value"
#     db_vpc_name          = "value"
#     drill_vpc_cidr       = "value"
#     drill_vpc_name       = "value"
#     subnet_web_name      = "value"
#     subnet_web_cidr      = "value"
#     subnet_web_gateway   = "192.168.0.1"
#     subnet_db_gateway    = "172.16.0.1"
#     subnet_drill_gateway = "10.0.0.1"
#   }
# }
