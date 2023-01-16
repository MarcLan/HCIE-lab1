# Subnets
output "subnet_web_id" {
  value = huaweicloud_vpc_subnet.subnet_web.id
}

output "subnet_db_id" {
  value = huaweicloud_vpc_subnet.subnet_db.id
}

output "subnet_web_branch_id" {
  value = huaweicloud_vpc_subnet.subnet_web_branch.id
}

output "subnet_db_dr_id" {
  value = huaweicloud_vpc_subnet.subnet_db_dr.id
}

# VPCs
output "vpc_web_active_id" {
  value = huaweicloud_vpc.vpc_web_active.id
}

output "vpc_db_active_id" {
  value = huaweicloud_vpc.vpc_db_active.id
}

output "vpc_drill_active_id" {
  value = huaweicloud_vpc.vpc_drill_active.id
}

output "vpc_web_branch_id" {
  value = huaweicloud_vpc.vpc_web_branch.id
}

output "vpc_db_dr_id" {
  value = huaweicloud_vpc.vpc_db_dr.id
}


# Elb
output "elb_subnet_web_id" {
  value = huaweicloud_vpc_subnet.subnet_web.subnet_id
}

output "elb_subnet_web_branch_id" {
  value = huaweicloud_vpc_subnet.subnet_web_branch.subnet_id
}

