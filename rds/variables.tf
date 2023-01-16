variable "rds" {
  type = object({
    bkk_name     = string
    hk_name      = string
    bkk_port     = string
    hk_port      = string
    bkk_password = string
    hk_password  = string
    bkk_database = string
  })
}

variable "bkk_vpc_id" {
  type = string
}

variable "bkk_subnet_id" {
  type = string
}

variable "bkk_security_group_id" {
  type = string
}

variable "hk_vpc_id" {
  type = string
}

variable "hk_subnet_id" {
  type = string
}

variable "hk_security_group_id" {
  type = string
}

variable "network_id" {
  type = string
}

