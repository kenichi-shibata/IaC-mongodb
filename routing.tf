

# Grant the VPC internet access on its main route table using default route
resource "aws_default_route_table" "public_access_table" {
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
resource "aws_route_table" "private_subnet_table" {
  vpc_id	= "${aws_vpc.main.id}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-private-route"
	}
	depends_on = ["aws_nat_gateway.gw"]
}

resource "aws_route" "private_subnet_route" {
	route_table_id	= "${aws_route_table.private_subnet_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.gw.id}"
	depends_on = ["aws_route_table.private_subnet_table"]
}

# Create a routing table for NAT and Private subnet
resource "aws_route_table" "private_secondary_subnet_table" {
  vpc_id	= "${aws_vpc.main.id}"

	tags = {
		Name = "${var.pre_tag}-${var.service_name}-private-secondary-route"
	}
	depends_on = ["aws_nat_gateway.gw_secondary"]
}

resource "aws_route" "private_secondary_subnet_route" {
	route_table_id	= "${aws_route_table.private_secondary_subnet_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.gw_secondary.id}"
	depends_on = ["aws_route_table.private_subnet_table"]
}

resource "aws_route_table_association" "management_association" {
	subnet_id = "${aws_subnet.management.id}"
	route_table_id = "${aws_default_route_table.public_access_table.id}"
	depends_on = ["aws_default_route_table.public_access_table"]
}

resource "aws_route_table_association" "public_association" {
	subnet_id = "${aws_subnet.public_primary.id}"
	route_table_id = "${aws_default_route_table.public_access_table.id}"
	depends_on = ["aws_default_route_table.public_access_table"]
}

resource "aws_route_table_association" "private_association" {
	subnet_id = "${aws_subnet.private_primary.id}"
	route_table_id = "${aws_route_table.private_subnet_table.id}"
	depends_on = ["aws_route.private_subnet_route"]
}

resource "aws_route_table_association" "public_secondary_association" {
	subnet_id = "${aws_subnet.public_secondary.id}"
	route_table_id = "${aws_default_route_table.public_access_table.id}"
	depends_on = ["aws_default_route_table.public_access_table"]
}

resource "aws_route_table_association" "private_secondary_association" {
	subnet_id = "${aws_subnet.private_secondary.id}"
	route_table_id = "${aws_route_table.private_secondary_subnet_table.id}"
	depends_on = ["aws_route.private_subnet_route"]
}
