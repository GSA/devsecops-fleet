resource "aws_iam_role" "kolide_master_ec2_role" {
    name = "${var.kolide_iam_role_name}"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": "ec2.amazonaws.com"
            },
                "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "kolide_ec2_instance_profile" {
    name = "${var.kolide_ec2_instance_profile_name}"
    role = "${aws_iam_role.kolide_master_ec2_role.name}"
}