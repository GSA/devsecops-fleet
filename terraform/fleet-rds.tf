resource "aws_security_group" "kolide_rds_security_group" {
  name        = "kolide_rds_security_group"
  description = "Allow inbound traffic for security group"
  vpc_id      = "${data.terraform_remote_state.infrastructure_remote_state.vpc_id}"

  ingress {
    from_port   = "${var.kolide_rds_port}"
    to_port     = "${var.kolide_rds_port}"
    protocol    = "tcp"
    cidr_blocks = "${var.kolide_ingress_cidr_blocks}"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# TODO: Enable enhanced monitoring

module "kolide_rds_database" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "${var.kolide_rds_identifier}"

  engine = "${var.kolide_rds_db_engine}"
  engine_version = "${var.kolide_rds_db_engine_version}"
  publicly_accessible = "${var.kolide_rds_publicly_accessible}"
  instance_class = "${var.kolide_rds_instance_type}"
  allocated_storage = "${var.kolide_rds_db_size}"
  storage_type = "${var.kolide_rds_db_storage_type}"
  storage_encrypted = "${var.kolide_storage_encrypted}"

  multi_az = "${var.kolide_rds_multi_az}"
  
  kms_key_id = "${var.kolide_rds_encryption_kms_key_id}"
  name = "${var.kolide_rds_db_name}"
  username = "${var.kolide_rds_username}"
  password = "${var.kolide_rds_password}"
  port = "${var.kolide_rds_port}"

  vpc_security_group_ids = ["${aws_security_group.kolide_rds_security_group.id}"]

  maintenance_window = "${var.kolide_rds_maintenance_window}"
  backup_window = "${var.kolide_rds_backup_window}"

  backup_retention_period = "${var.kolide_rds_backup_retention_period}"

#   tags = {
#     Owner = "user"
#     Environment = "dev"
#   }

  # DB subnet group
  subnet_ids = ["${data.terraform_remote_state.infrastructure_remote_state.database_subnet_ids}"]
  
  # DB parameter group
  family = "${var.kolide_rds_parameter_group_family}"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "${var.kolide_final_snapshot_identifier}"
}