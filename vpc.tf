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
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-management"
	}
}

resource "aws_subnet" "public_primary" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-public"
	}
}

resource "aws_subnet" "private_primary" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
	tags = {
		Name = "${var.pre_tag}-${var.service_name}-private"
	}
}

## create an elastic ip
resource "aws_eip" "nat_eip" {
  vpc      = true
}

## create a nat gateway for private_primary subnet
resource "aws_nat_gateway" "gw" {
    allocation_id = "${aws_eip.nat_eip.id}"
    subnet_id = "${aws_subnet.public_primary.id}"
}
