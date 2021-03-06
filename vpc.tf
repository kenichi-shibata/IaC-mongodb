# Gets the list of availability zones in selected aws region
data "aws_availability_zones" "available" {
	state = "available"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-vpc"
	}
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default-igw" {
  vpc_id = "${aws_vpc.main.id}"
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-igw"
	}
}


# Create subnets to launch our instances into
resource "aws_subnet" "management" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-management"
	}
}

resource "aws_subnet" "public_primary" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.16.0/20"
	availability_zone 			= "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-primary-public"
	}
}

resource "aws_subnet" "private_primary" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.32.0/20"
	availability_zone 			= "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = false
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-primary-private"
	}
}

resource "aws_subnet" "public_secondary" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.48.0/20"
	availability_zone 			= "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-secondary-public"
	}
}

resource "aws_subnet" "private_secondary" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.64.0/20"
	availability_zone 			= "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = false
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-secondary-private"
	}
}
## create an elastic ip
resource "aws_eip" "nat_eip_primary" {
  vpc      = true
}

## create a nat gateway for private_primary subnet
resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat_eip_primary.id}"
    subnet_id = "${aws_subnet.public_primary.id}"
}

## create an elastic ip
resource "aws_eip" "nat_eip_secondary" {
  vpc      = true
}

## create a nat gateway for private_primary subnet
resource "aws_nat_gateway" "gw_secondary" {
    allocation_id = "${aws_eip.nat_eip_secondary.id}"
    subnet_id = "${aws_subnet.public_secondary.id}"
}
