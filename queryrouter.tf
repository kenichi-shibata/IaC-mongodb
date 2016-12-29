resource "aws_instance" "query_router" {
	ami = "${lookup(var.amazon_amis, var.region)}"
	count = "${var.count_queryrouter}"
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-query0${count.index}"
		Env = "${var.env_tag}"
	}

	depends_on = ["aws_security_group.allow_mongodb"]
	instance_type = "${var.instance_type_queryrouter}"
	ebs_optimized = "${var.ebs_optimized}"
	tenancy = "${var.tenancy_queryrouter}"
	key_name = "${var.key_pair}"
	/*disable_api_termination = "true"*/
	monitoring = "true"

	subnet_id = "${lookup(map("0","${aws_subnet.private_primary.id}","1","${aws_subnet.private_secondary.id}"),count.index % 2)}"
	associate_public_ip_address = false
	vpc_security_group_ids =  ["${aws_security_group.allow_mongodb.id}"]

	root_block_device = {
		volume_type = "io1"
		volume_size = "${var.volume_size_queryrouter}"
		iops = "${var.volume_iops_queryrouter}"
		/*delete_on_termination = "false"*/
	}

}

output "query_router" {
	value = ["${aws_instance.query_router.*.private_ip}"]
}
