resource "aws_instance" "vpn_server" {
	ami = "${lookup(var.amazon_amis, var.region)}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-openvpn"
		Env = "${var.env_tag}"
	}

	instance_type = "${var.instance_type_openvpn}"
	ebs_optimized = "${var.ebs_optimized}"
	key_name = "${var.key_pair}"
	subnet_id = "${aws_subnet.public_primary.id}"
	associate_public_ip_address = true
	depends_on = ["aws_security_group.openvpn_ports"]
	vpc_security_group_ids =  ["${aws_security_group.openvpn_ports.id}"]
}

resource "aws_security_group" "openvpn_ports" {
  name = "openvpn_traffic"
  description = "Allow all openvpn default traffic"
	vpc_id = "${aws_vpc.main.id}"

  ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

	ingress {
			from_port = 943
			to_port = 943
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
			from_port = 1194
			to_port = 1194
			protocol = "udp"
			cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
			from_port = 1194
			to_port = 1194
			protocol = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
	  from_port = 0
	  to_port = 0
	  protocol = "icmp"
	  cidr_blocks = ["${aws_vpc.main.cidr_block}"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
	tags {
		Name = "allow_openvpn_traffic"
	}
}

output "openvpn_server" {
	value = "${aws_security_group.openvpn_ports.private_ip}"
}
