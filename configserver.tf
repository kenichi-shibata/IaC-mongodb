provider "aws" {
    region = "${var.region}"
}

resource "aws_instance" "cfg01" {
	ami = "${lookup(var.amazon_amis, var.region)}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-cfg01"
		env = "${var.env_tag}"
	}

	instance_type = "${var.instance_type_configsvr}"
	ebs_optimized = "${var.ebs_optimized}"
	key_name = "${var.key_pair}"
	subnet_id = "${aws_subnet.private_primary.id}"
	associate_public_ip_address = true
	depends_on = ["aws_security_group.allow_mongodb"]
	vpc_security_group_ids =  ["${aws_security_group.allow_mongodb.id}"]
}

resource "aws_instance" "cfg02" {
	ami = "${lookup(var.amazon_amis, var.region)}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-cfg02"
		env = "${var.env_tag}"
	}

	instance_type = "${var.instance_type_configsvr}"
	ebs_optimized = "${var.ebs_optimized}"
	key_name = "${var.key_pair}"
	subnet_id = "${aws_subnet.private_primary.id}"
	associate_public_ip_address = false
	vpc_security_group_ids =  ["${aws_security_group.allow_mongodb.id}"]
}

resource "aws_instance" "cfg03" {
	ami = "${lookup(var.amazon_amis, var.region)}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-cfg03"
		env = "${var.env_tag}"
	}

	instance_type = "${var.instance_type_configsvr}"
	ebs_optimized = "${var.ebs_optimized}"
	key_name = "${var.key_pair}"
	subnet_id = "${aws_subnet.private_primary.id}"
	associate_public_ip_address = false
	vpc_security_group_ids =  ["${aws_security_group.allow_mongodb.id}"]
}


resource "aws_security_group" "allow_mongodb" {
  name = "mongodb_only"
  description = "Allow all mongodb traffic padded"
	vpc_id = "${aws_vpc.main.id}"
  ingress {
      from_port = 27015
      to_port = 27020
      protocol = "tcp"
      cidr_blocks = ["${aws_vpc.main.cidr_block}"]
  }

	egress {
			from_port = 0
			to_port = 0
			protocol = "-1"
			cidr_blocks = ["0.0.0.0/0"]
	}

	tags {
		Name = "mongodb_security"
	}
}


output "cfg01" {
	value = "${aws_instance.cfg01.private_ip}"
}

output "cfg02" {
	value = "${aws_instance.cfg02.private_ip}"
}

output "cfg03" {
	value = "${aws_instance.cfg03.private_ip}"
}
