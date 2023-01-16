# variable "ecs_name" {
#   type = string
# }

# variable "ecs_uuid" {
#   type = string
# }

variable "connection_ecs_name_bkk" {
  type = object({
    ecs_web_name_bkk = string
    ecs_db_name_bkk  = string
  })
}

variable "connection_ecs_name_hk" {
  type = object({
    ecs_web_name_hk = string
    ecs_db_name_hk  = string
  })
}

variable "ecs_web_uuid_bkk" {}
variable "ecs_db_uuid_bkk" {}

variable "ecs_web_uuid_hk" {}
variable "ecs_db_uuid_hk" {}
