resource "null_resource" "bootstrap_config_svr" {
	depends_on = ["aws_instance.query_router"]
	depends_on = ["aws_instance.vpn_server"]
	count = "${var.count_configsvr}"

	triggers {
		query_router_cluster = "${join(",",aws_instance.query_router.*.id)}"
	}
	connection {
		host = "${element(aws_instance.query_router.*.private_ip, count.index)}"
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
		 	"sudo service ntpd restart",
			"sudo chkconfig ntpd on",
			"sudo yum install -y mongodb-org",
			"sudo service mongod start",
			"sudo cat /var/log/mongodb/mongod.log",
			"sudo chkconfig mongod on",
		]
		connection {
			user = "ec2-user"
			bastion_host = "${aws_instance.vpn_server.public_ip}"
		}
	}
}

/* add config svr specific setup to servers*/
data "template_file" "config_svr" {
	template = "${file("${path.module}/templates/configserver.conf")}"
	count = "${var.count_configsvr}"
	vars {
		bindIp = "${element(aws_instance.query_router.*.private_ip, count.index)}"
		clusterRole = "configsvr"
		replSetName = "query_router0"
	}
}

resource "null_resource" "config_svr_mongodb" {
	depends_on = ["null_resource.bootstrap_mongodb"]
	count = "${var.count_configsvr}"

	triggers {
		query_router_cluster = "${join(",",aws_instance.query_router.*.id)}"
	}
	connection {
		host = "${element(aws_instance.query_router.*.private_ip, count.index)}"
	}

/* remove and recreate default mongod.conf */
	provisioner "remote-exec" {
		inline = [
			"sudo rm -rf /etc/mongod.conf || echo 'suppressing errors!'",
			"sudo tee /etc/mongod.conf <<EOF",
			"${element(data.template_file.config_svr.*.rendered, count.index)}",
			"EOF",
			"sudo service mongod restart",
		]
		connection {
			user = "ec2-user"
			bastion_host = "${aws_instance.vpn_server.public_ip}"
		}
	}
}
