provider "aws" {
    region = "${var.region}"
}

resource "aws_instance" "cfg" {
	ami = "${lookup(var.amazon_amis, var.region)}"
	count = "${var.count_configsvr}"
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-cfgsvr0${count.index}"
		Env = "${var.env_tag}"
	}

	depends_on = ["aws_security_group.allow_mongodb"]
	instance_type = "${var.instance_type_configsvr}"
	ebs_optimized = "${var.ebs_optimized}"
	tenancy = "${var.tenancy_configsvr}"
	key_name = "${var.key_pair}"
	/*disable_api_termination = "true" for terraform destroy*/
	monitoring = "true"

	subnet_id = "${lookup(map("0","${aws_subnet.private_primary.id}","1","${aws_subnet.private_secondary.id}"),count.index % 2)}"
	associate_public_ip_address = false
	vpc_security_group_ids =  ["${aws_security_group.allow_mongodb.id}"]

	root_block_device = {
		volume_type = "io1"
		volume_size = "${var.volume_size_configsvr}"
		iops = "${var.volume_iops_configsvr}"
		/*delete_on_termination = "false" this is causing issues*/
	}

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

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
    cidr_blocks = ["${aws_vpc.main.cidr_block}"]
	}

	ingress {
	  from_port = 0
	  to_port = 0
	  protocol = "icmp"
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


output "config_svr" {
	value = ["${aws_instance.cfg.*.private_ip}"]
}
