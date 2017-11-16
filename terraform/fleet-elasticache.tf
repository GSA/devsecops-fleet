module "kolide_redis" {
  source = "github.com/terraform-community-modules/tf_aws_elasticache_redis?ref=1.0.1"
  env = "${var.kolide_redis_environment}"
  name = "${var.kolide_redis_cluster_name}"
  redis_clusters = "${var.kolide_redis_clusters}"
  redis_failover = "${var.kolide_redis_failover}"
  allowed_cidr = "${var.kolide_redis_allowed_cidr}"
  redis_node_type = "${var.kolide_redis_node_type}"
  subnets = "${data.terraform_remote_state.infrastructure_remote_state.database_subnet_ids}"
  vpc_id = "${data.terraform_remote_state.infrastructure_remote_state.vpc_id}"
}