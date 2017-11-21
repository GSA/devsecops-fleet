output "kolide_public_ip" {
    value = "${aws_eip.devsecops_kolide_eip.public_ip}"
}

output "kolide_elasticache_endpoint" {
    value = "${module.kolide_redis.endpoint}"
}

output "kolide_rds_endpoint" {
    value = "${module.kolide_rds_database.this_db_instance_endpoint}"
}