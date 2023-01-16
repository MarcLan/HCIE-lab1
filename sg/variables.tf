variable "sg" {
  type = object({
    bkk_sg_web_name = string
    bkk_sg_db_name  = string
    hk_sg_web_name = string
    hk_sg_db_name  = string
  })
}

# variable "sg_rule" {
#   type = object({
#     direction         = string
#     ethertype         = string
#     protocaol         = string
#     remote_ip_prefix  = string
#     security_group_id = string
#   })
# }
