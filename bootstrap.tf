resource "null_resource" "bootstrap_mongodb" {
	depends_on = ["aws_instance.cfg"]
	depends_on = ["aws_instance.vpn_server"]
	count = "${var.count_configsvr}"

	triggers {
		cfg_cluster = "${join(",",aws_instance.cfg.*.id)}"
	}
	connection {
		host = "${element(aws_instance.cfg.*.private_ip, count.index)}"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo tee /etc/yum.repos.d/mongodb-org-3.4.repo <<- 'EOF'",
			"[mongodb-org-3.4]",
			"name=MongoDB Repository",
			"baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.4/x86_64/",
			"gpgcheck=1",
			"enabled=1",
			"gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc",
			"EOF",
		]
		connection {
			user = "ec2-user"
			bastion_host = "${aws_instance.vpn_server.public_ip}"
		}
	}

	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y",
			"sudo yum install -y mongodb-org",
			"sudo service mongod start",
			"sudo mcat /var/log/mongodb/mongod.log",
			"sudo chkconfig mongod on",
		]
		connection {
			user = "ec2-user"
			bastion_host = "${aws_instance.vpn_server.public_ip}"
		}
	}
}
