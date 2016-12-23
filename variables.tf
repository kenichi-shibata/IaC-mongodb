
#Pre tag to append to all resources
variable "pre_tag" {
  description = "Pre Tag for all the resources"
  default = "pre"
}
#Post tag to append to all resources
variable "post_tag" {
  description = "Post Tag for all the resources"
  default = "post"
}
#Environment Tag
variable "env_tag" {
  description = "Name of Environment"
  default = "staging"
}

variable "service_name" {
  description = "name of the service"
}

variable "instance_type_openvpn"  {
  description = "instance type of the first ec2 instance"
}

variable "instance_type_configsvr" {
	default = "m3.large"
	description = "instance type of the config server"
}

variable "ebs_optimized" {
  description = "instance status"
}

variable "region" {
  description = "aws region"
	default = "ap-northeast-1"
}

variable "key_pair" {
  description = "aws keypair"
	default = "id_rsa"
}

variable "count_configsvr" {
  default = "3"
	description = "Number of config servers to be used"
}

variable "tenancy_configsvr" {
  default = "shared"
	description = "Harware tenancy of the config server"
}

variable "volume_iops_configsvr" {
	default = "2000"
	description = " IOPS for the aws ebs config server/s"
}

variable "volume_size_configsvr" {
	default = "100"
	description = "EBS ssd io1 block size for the config server"
}


variable "centos_amis" {
  description = "CentOS AMIs by region"
  default = {
    ap-southeast-1 = "ami-f068a193"
    ap-northeast-1 = "ami-eec1c380"
    ap-south-1 = "ami-95cda6fa"
    us-east-1 = "ami-6d1c2007"
    us-west-1 = "ami-af4333cf"
    us-west-2 = "ami-d2c924b2"
  }
}

variable "amazon_amis" {
	description = "Amazon AMIs by region"
	default = {
		ap-southeast-1 = "ami-b953f2da"
		ap-northeast-1 = "ami-0c11b26d"
		ap-south-1 = "ami-34b4c05b"
		us-east-1 = "ami-b73b63a0"
		us-west-1 = "ami-5ec1673e"
		us-west-2 = "ami-23e8a343"
	}
}
/*
variable "availability_zones" {
	description = "availability_zones which are near in tokyo or are in tokyo"
	default = {
		zone0 = "ap-northeast-1a"
		zone1 = "ap-northeast-1c"
		zone2 = "ap-northeast-2a"
		zone3 = "ap-northeast-2c"
	}
}

variable "cidr_block_management" {
  default = "10.0.0.0/20"
}

variable "cidr_blocks_public" {
	description = "cidr blocks for 10.0.0.0/16 (vpc default) to be used by public subnets"
	default = {
		block0 = "10.0.16.0/20"
		block1 = "10.0.32.0/20"
		block2 = "10.0.48.0/20"
		block3 = "10.0.64.0/20"
	}
}

variable "cidr_blocks_private" {
	description = "cirdr"
	default = {
		block0 = "10.0.80.0/20"
		block1 = "10.0.96.0/20"
		block2 = "10.0.112.0/20"
		block3 = "10.0.128.0/20"
	}
}*/
