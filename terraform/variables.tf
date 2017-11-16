variable "region" {
    description = "The AWS region to create resources in."
    default = "us-east-1"
}

variable "az1" {
    default = "us-east-1d"
}

variable "az2" {
    default = "us-east-1e"
}

variable "remote_state_backend_type" {
    description = "The remote state backend, if you’re planning to hook this up to an existing DevSecOps-Infrastructure deployment."
    type = "string"
    default = "s3"
}

variable "remote_state_backend_bucket" {
    description = "The remote state backend bucket."
    type = "string"
}

variable "remote_state_backend_key" {
    description = "The remote state key for the terraform.tfstate file. Ex: devsecops-infrastructure/terraform.tfstate"
    type = "string"
}

variable "vpc_id" {
    description = "The VPC ID for the Kolide security group. If you do not specify this, the deployment will attempt to use the vpc-mgmt VPC ID from the DevSecOps-Infrastructure deployment. You MUST have the remote_state_backend variables defined above for that to work."
    type = "string"
    default = ""
}

variable "kolide_key_name" {
    description = "The key pair name for the kolide instance. The key pair must already exist in the AWS account."
    type = "string"
    default = "kolide-ec2"
}

variable "kolide_sg_name" {
    description = "The name of the new kolide security group."
    type = "string"
    default = "sg_kolide_ec2"
}

variable "kolide_instance_subnet_id" {
    description = "The subnet ID to place the kolide instance. If you do not specify this, the deployment will attempt to use the vpc-mgmt public subnet_id from the DevSecOps-Infrastructure deployment. You MUST have the remote_state_backend variables defined above for that to work."
    type = "string"
    default = ""
}

variable "kolide_http_cidrs" {
    description = "List of CIDR ranges to allow http/https access to the instance."
    type = "list"
    default = ["0.0.0.0/0"]
}

variable "kolide_ssh_cidrs" {
    description = "List of CIDR ranges to allow ssh access to the instances."
    type = "list"
    default = ["0.0.0.0/0"]
}

variable "kolide_instance_name" {
    description = "Name of the instance that will be created."
    type = "string"
    default = "kolide"
}

variable "kolide_ami_id" {
    description = "AMI ID to use for the kolide instance."
    type = "string"
    default = "ami-da05a4a0"
}

variable "kolide_instance_type" {
    description = "Instance type for the kolide instance."
    type = "string"
    default = "t2.micro"
}

variable "kolide_iam_role_name" {
    description = "Name for the IAM EC2 instance role that will be created."
    type = "string"
    default = "kolide_ec2_role"
}

variable "kolide_ec2_instance_profile_name" {
    description = "Name of the instance profile"
    type = "string"
    default = "kolide_ec2_role_instance_profile"
}

variable "kolide_private_master_dns" {
    description = "Private DNS hostname for the kolide instance"
    type = "string"
    default = "kolide.devsecops.local"
}

variable "kolide_vm_user" {
    description = "Name of the ssh user to use."
    type = "string"
    default = "ec2-user"
}

variable "kolide_rds_db_engine" {
    description = "RDS database engine for Kolide"
    type = "string"
    default = "mysql"
}

variable "kolide_rds_publicly_accessible" {
    description = "Is the RDS instance publicly accessible? (boolean)"
    type = "string"
    default = "false"
}

variable "kolide_rds_port" {
    description = "TCP port of the instance"
    type = "string"
    default = "3306"
}

variable "kolide_rds_db_engine_version" {
    description = "RDS MYSQL database engine version"
    type = "string"
    default = "5.7.19"
}

variable "kolide_rds_identifier" {
    description = "RDS identifier"
    type = "string"
    default = "kolide"
}

variable "kolide_rds_backup_retention_period" {
    description = "Number of backups to retain"
    type = "string"
    default = "0"
}

variable "kolide_rds_maintenance_window" {
    description = "Maintenance window of the RDS instance"
    type = "string"
    default = "Mon:00:00-Mon:03:00"
}

variable "kolide_rds_backup_window" {
    description = "RDS Backup window"
    type = "string"
    default = "03:00-06:00"
}

variable "kolide_rds_db_name" {
    description = "Name of kolide database"
    type = "string"
    default = "kolide"
}

variable "kolide_rds_db_size" {
    description = "RDS database size"
    type = "string"
    default = "20"
}

variable "kolide_rds_instance_type" {
    description = "RDS instance type"
    type = "string"
    default = "db.t2.micro"
}

variable "kolide_rds_db_storage_type" {
    description = "Storage type"
    type = "string"
    default = "gp2"
}

variable "kolide_rds_multi_az" {
    description = "Boolean - set this RDS instance to multi-az or not"
    type = "string"
    default = "false"
}

variable "kolide_storage_encrypted" {
    description = "Boolean - encrypt the storage. If true, KMS ARN MUST be provided."
    type = "string"
    default = "false"
}

variable "kolide_final_snapshot_identifier" {
    description = "Name to apply to the final snapshot if the RDS instance gets deleted"
    type = "string"
    default = "kolide-FINAL"
}

variable "kolide_rds_encryption_kms_key_id" {
    description = "ARN of the KMS Key ID to encrypt storage"
    type = "string"
    default = ""
}

variable "kolide_rds_username" {
    description = "Kolide RDS username"
    type = "string"
    default = "kolide"
}

variable "kolide_rds_password" {
    description = "Kolide RDS password"
    type = "string"
    default = "kolide123"
}

variable "kolide_rds_subnet_group" {
    description = "Subnet group name for RDS, likely already deployed in another stack. Leave blank to set to the previously-deployed stack."
    type = "string"
    default = ""
}

variable "kolide_ingress_cidr_blocks" {
    description = "Ingress CIDR blocks for RDS instance"
    type = "list"
    default = ["10.0.0.0/16"]
}

variable "kolide_rds_parameter_group_family" {
    description = "Parameter group family for RDS"
    type = "string"
    default = "mysql5.7"
}

variable "kolide_rds_stack_description" {
    description = "Description for the RDS networks"
    type = "string"
    default = "Kolide fleet RDS instance"
}