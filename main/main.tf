######################################################################
# Region & AKSK
######################################################################

provider "huaweicloud" {
  region     = "ap-southeast-2"
  access_key = "S9MEZ7ROWLZGLBFXVIBL"
  secret_key = "ngBBuXcB97VAHPJ83vSgM3oWZ1ubyY1Rh8Aqt2GQ"
}

######################################################################
# VPC & Subnet
######################################################################

module "vpc" {
  vpc = ({
    # BKK VPC & Subnet
    vpc_web_active_name = "web_active"
    vpc_web_active_cidr = "192.168.0.0/16"
    subnet_web_name     = "subnet_web"
    subnet_web_cidr     = "192.168.0.0/24"

    vpc_db_active_name = "db_active"
    vpc_db_active_cidr = "172.16.0.0/12"
    subnet_db_name     = "subnet_db"
    subnet_db_cidr     = "172.16.0.0/24"

    vpc_drill_active_name = "drill_active"
    vpc_drill_active_cidr = "10.0.0.0/8"
    subnet_drill_name     = "subnet_drill"
    subnet_drill_cidr     = "10.0.0.0/24"

    # HK VPC & Subnet
    vpc_web_branch_name    = "web_branch"
    vpc_web_branch_cidr    = "192.168.0.0/16"
    subnet_web_branch_name = "web_branch"
    subnet_web_branch_cidr = "192.168.1.0/24"

    vpc_db_dr_name    = "db_dr"
    vpc_db_dr_cidr    = "172.16.0.0/12"
    subnet_db_dr_name = "db_dr"
    subnet_db_dr_cidr = "172.16.1.0/24"
  })
  source = "../vpc/"
}

######################################################################
# Security Group
######################################################################

module "sg" {
  # BKK & HK sg name
  sg = ({
    bkk_sg_web_name = "sg_web"
    bkk_sg_db_name  = "sg_db"
    hk_sg_web_name  = "sg_web"
    hk_sg_db_name   = "sg_db"
  })
  source = "../sg/"
}

#####################################################################
# ECS
#####################################################################

module "ecs" {
  # BKK ECS name
  connection_ecs_name_bkk = ({
    ecs_web_name_bkk = "web_connection_test_bkk"
    ecs_db_name_bkk  = "db_connection_test_bkk"
  })

  # HK ECS name
  connection_ecs_name_hk = ({
    ecs_web_name_hk = "web_connection_test_hk"
    ecs_db_name_hk  = "db_connection_test_hk"
  })

  ###
  ecs_web_uuid_bkk = module.vpc.subnet_web_id
  ecs_db_uuid_bkk  = module.vpc.subnet_db_id
  ecs_web_uuid_hk  = module.vpc.subnet_web_branch_id
  ecs_db_uuid_hk   = module.vpc.subnet_db_dr_id
  source           = "../ecs"
}

######################################################################
# RDS
######################################################################

module "rds" {

  rds = ({
    # BKK RDS instance
    bkk_name     = "wordpress"
    bkk_port     = "3310"
    bkk_password = "P@ssw0rdHCIE0lab999"
    bkk_database = "wordpress"

    # HK RDS instance
    hk_name     = "wordpress"
    hk_port     = "3310"
    hk_password = "P@ssw0rdHCIE0lab999"
  })

  ###
  bkk_vpc_id            = module.vpc.vpc_web_active_id
  bkk_subnet_id         = module.vpc.subnet_web_id
  bkk_security_group_id = module.sg.security_group_bkk_db_id
  network_id            = module.vpc.subnet_db_id
  hk_vpc_id             = module.vpc.vpc_db_dr_id
  hk_subnet_id          = module.vpc.subnet_db_dr_id
  hk_security_group_id  = module.sg.security_group_hk_db_id
  source                = "../rds"
}

######################################################################
# DRS
######################################################################

module "drs" {
  # DRS name
  name = "wordpress"

  # Source DB configration
  source_port     = 3310
  source_user     = "root"
  source_password = "P@ssw0rdHCIE0lab999"

  # Destinationg DB confgration
  destination_password = "P@ssw0rdHCIE0lab999"

  ###
  source_ip                      = module.rds.bkk_rds_public_ip
  destination_instance_id        = module.rds.hk_rds_id
  destination_ip                 = module.rds.hk_rds_ip
  destination_instance_subnet_id = module.rds.hk_rds_sunbet_id
  source                         = "../drs"
}


######################################################################
# DCS
######################################################################

module "dcs" {
  source    = "../dcs"
  vpc_id    = module.vpc.vpc_db_active_id
  subnet_id = module.vpc.subnet_db_id
}

######################################################################
# NAT
######################################################################

module "nat" {
  # NAT name
  name = "wordpresss"

  ###
  vpc_id    = module.vpc.vpc_web_active_id
  subnet_id = module.vpc.subnet_web_id
  source    = "../nat"
}

######################################################################
# ELB
######################################################################

module "elb" {

  # ELB name
  bkk_name = "wordpress"
  hk_name  = "wordpress"

  ###
  bkk_vpc_id         = module.vpc.vpc_web_active_id
  bkk_ipv4_subnet_id = module.vpc.elb_subnet_web_id
  hk_vpc_id          = module.vpc.vpc_web_branch_id
  hk_ipv4_subnet_id  = module.vpc.elb_subnet_web_branch_id
  source             = "../elb"
}

######################################################################
# VPN
######################################################################

module "vpn" {
  # VPN name
  bkk_name   = "bkk_to_hk"
  hk_name    = "hk_to_bkk"

  ###
  bkk_vpc_id = module.vpc.vpc_db_active_id
  hk_vpc_id  = module.vpc.vpc_web_branch_id
  source     = "../vpn"
}

######################################################################
# DNS
######################################################################

module "dns" {
  # DNS domain
  dns_name  = "hcie-xxxx.com"

  ###
  router_id = module.vpc.vpc_web_active_id
  source    = "../dns"
}

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
