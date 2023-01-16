

output "bkk_rds_ip" {
  value = huaweicloud_rds_instance.bkk_rds_instance.public_ips
}

output "hk_rds_ip" {
  value = huaweicloud_rds_instance.hk_rds_instance.fixed_ip
}

output "hk_rds_id" {
  value = huaweicloud_rds_instance.hk_rds_instance.id
}

output "hk_rds_sunbet_id" {
  value = huaweicloud_rds_instance.hk_rds_instance.subnet_id
}

output "bkk_rds_public_ip" {
  value = huaweicloud_vpc_eip.myeip.address
}