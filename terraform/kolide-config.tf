data "template_file" "kolide_vars" {
  template = "${file("${path.module}/kolide.tpl")}"

  vars {
    kolide_rds_endpoint = "${module.kolide_rds_database.this_db_instance_endpoint}"
    kolide_elasticache_endpoint = "${var.kolide_redis_endpoint}"
    kolide_rds_db_name = "${var.kolide_rds_db_name}"
    kolide_rds_username = "${var.kolide_rds_username}"
    kolide_rds_password = "${var.kolide_rds_password}"
    kolide_jwt_key = "${var.kolide_jwt_key}"
  }
}

resource "local_file" "kolide_config_rendered_file" {
    content = "${data.template_file.kolide_vars.rendered}"
    filename = "${path.module}/../ansible/playbooks/files/kolide.j2"
}