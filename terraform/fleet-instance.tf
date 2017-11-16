resource "aws_security_group" "devsecops_kolide_sg" {
  name = "${var.kolide_sg_name}"
  description = "Kolide fleet security group"

  vpc_id = "${var.vpc_id == "" ? data.terraform_remote_state.infrastructure_remote_state.vpc_id : var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.kolide_http_cidrs}"]
  }

    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.kolide_ssh_cidrs}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devsecops_kolide_instance" {

  ami = "${var.kolide_ami_id}"
  instance_type = "${var.kolide_instance_type}"
  # TODO: Which public subnet?!
  subnet_id = "${var.kolide_instance_subnet_id == "" ? data.terraform_remote_state.infrastructure_remote_state.app_public_subnet_ids[0] : var.kolide_instance_subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.devsecops_kolide_sg.id}"]
  key_name = "${var.kolide_key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.kolide_ec2_instance_profile.id}"

  connection {
    user = "${var.kolide_vm_user}"
  }

  tags {
    "Name" = "${var.kolide_instance_name}"
  }

}

resource "aws_eip" "devsecops_kolide_eip" {
  vpc = true
  instance = "${aws_instance.devsecops_kolide_instance.id}"
}

resource "null_resource" "eip_connection_test" {
  triggers {
    eip = "${aws_eip.devsecops_kolide_eip.public_ip}"
  }

  connection {
      host = "${aws_eip.devsecops_kolide_eip.public_ip}"
      user = "${var.kolide_vm_user}"
      agent = true
  }

  # force Terraform to wait until a connection can be made, so that Ansible doesn't fail when trying to provision
  provisioner "remote-exec" {
    inline = [
      "echo 'Remote execution to Elastic IP address succeeded.'"
    ]
  }
}