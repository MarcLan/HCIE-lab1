variable "vpc" {
  type = object({
    # web_active
    vpc_web_active_name = string
    vpc_web_active_cidr = string
    subnet_web_name     = string
    subnet_web_cidr     = string
    #subnet_web_gateway  = string
    #subnet_web_id       = string

    # db_active
    vpc_db_active_name = string
    vpc_db_active_cidr = string
    subnet_db_cidr     = string
    subnet_db_name     = string
    #subnet_db_gateway  = string

    # drill_active
    vpc_drill_active_name = string
    vpc_drill_active_cidr = string
    subnet_drill_cidr     = string
    subnet_drill_name     = string
    #subnet_drill_gateway  = string

    # web_branch
    vpc_web_branch_name    = string
    vpc_web_branch_cidr    = string
    subnet_web_branch_name = string
    subnet_web_branch_cidr = string

    vpc_db_dr_name    = string
    vpc_db_dr_cidr    = string
    subnet_db_dr_name = string
    subnet_db_dr_cidr = string
  })
}

# variable "vpc_list_name" {
#   type= list
#   default = ["",""]
# }

# variable "vpc_list_cidr" {
#   type= list
#   default = ["",""]
# }