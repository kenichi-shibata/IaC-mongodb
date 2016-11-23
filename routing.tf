

# Grant the VPC internet access on its main route table using default route
resource "aws_default_route_table" "public_access_igw" {
	default_route_table_id = "${aws_vpc.main.default_route_table_id}"
	route = {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.default-igw.id}"
	}

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-public-main-route"
	}
}

# Create a routing table for NAT and Private subnet
resource "aws_route_table" "private_subnet_nat" {
  vpc_id				         	 = "${aws_vpc.main.id}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-private-route"
	}
	depends_on = ["aws_nat_gateway.gw"]
}

resource "aws_route" "private_subnet_dest" {
	route_table_id	= "${aws_route_table.private_subnet_nat.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.gw.id}"
	depends_on = ["aws_route_table.private_subnet_nat"]
}

resource "aws_route_table_association" "management_association" {
	subnet_id = "${aws_subnet.management.id}"
	route_table_id = "${aws_default_route_table.public_access_igw.id}"
	depends_on = ["aws_default_route_table.public_access_igw"]
}

resource "aws_route_table_association" "public_association" {
	subnet_id = "${aws_subnet.public_primary.id}"
	route_table_id = "${aws_default_route_table.public_access_igw.id}"
	depends_on = ["aws_default_route_table.public_access_igw"]
}

resource "aws_route_table_association" "private_association" {
	subnet_id = "${aws_subnet.private_primary.id}"
	route_table_id = "${aws_route_table.private_subnet_nat.id}"
	depends_on = ["aws_route.private_subnet_dest"]
}
