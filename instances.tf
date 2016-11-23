provider "aws" {
    region = "${var.region}"
}

resource "aws_instance" "public_instance" {
	ami = "${lookup(var.amazon_amis, var.region)}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-${var.post_tag}"
		env = "${var.env_tag}"
	}

	instance_type = "${var.instance_type}"
	ebs_optimized = "${var.ebs_optimized}"
	key_name = "${var.key_pair}"
	subnet_id = "${aws_subnet.public_primary.id}"
	associate_public_ip_address = true
	depends_on = ["aws_security_group.allow_all"]
	vpc_security_group_ids =  ["${aws_security_group.allow_all.id}"]
}


resource "aws_instance" "private_instance" {
	ami = "${lookup(var.amazon_amis, var.region)}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-${var.post_tag}"
		env = "${var.env_tag}"
	}

	instance_type = "${var.instance_type}"
	ebs_optimized = "${var.ebs_optimized}"
	key_name = "${var.key_pair}"
	subnet_id = "${aws_subnet.private_primary.id}"
	associate_public_ip_address = false
	vpc_security_group_ids =  ["${aws_security_group.allow_all.id}"]
}

resource "aws_security_group" "allow_all" {
  name = "allow_all"
  description = "Allow all inbound traffic"
	vpc_id = "${aws_vpc.main.id}"
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
	tags {
		Name = "allow_all"
	}
}
