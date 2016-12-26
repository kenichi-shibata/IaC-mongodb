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
<<<<<<< HEAD
/* SANITY CHECK ping google.com to check if instance is connected and NAT is up */
	provisioner "remote-exec" {
		inline = [
			"while true;
				do ping -c1 www.google.com > /dev/null && echo 'internet is up' && break;
				sleep 5;
			done; ",
			"sudo yum update -y",
		 	"sudo service ntpd restart",
			"sudo chkconfig ntpd on",
			"sudo yum install -y mongodb-org",
			"sudo service mongod start",
			"sudo cat /var/log/mongodb/mongod.log",
=======

	provisioner "remote-exec" {
		inline = [
			"sudo yum update -y",
			"sudo yum install -y mongodb-org",
			"sudo service mongod start",
			"sudo mcat /var/log/mongodb/mongod.log",
>>>>>>> added mongodb installer
			"sudo chkconfig mongod on",
		]
		connection {
			user = "ec2-user"
			bastion_host = "${aws_instance.vpn_server.public_ip}"
		}
	}
}
<<<<<<< HEAD

/* add config svr specific setup to servers*/
data "template_file" "config_svr" {
	template = "${file("${path.module}/templates/configserver.conf")}"
	count = "${var.count_configsvr}"
	vars {
		bindIp = "${element(aws_instance.cfg.*.private_ip, count.index)}"
	}
}

resource "null_resource" "config_svr_mongodb" {
	depends_on = ["null_resource.bootstrap_mongodb"]
	count = "${var.count_configsvr}"

	triggers {
		cfg_cluster = "${join(",",aws_instance.cfg.*.id)}"
	}
	connection {
		host = "${element(aws_instance.cfg.*.private_ip, count.index)}"
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
=======
>>>>>>> added mongodb installer
