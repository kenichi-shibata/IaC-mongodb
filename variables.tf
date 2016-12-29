
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

variable "instance_type_configsvr" {
	default = "m4.large"
	description = "instance type of the config server"
}

variable "count_configsvr" {
  default = "3"
	description = "Number of config servers to be used"
}

variable "tenancy_configsvr" {
  default = "default"
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

variable "instance_type_shardsvr" {
	default = "m4.large"
	description = "instance type of the config server"
}

variable "count_shardsvr" {
  default = "1"
	description = "Number of config servers to be used"
}

variable "count_shardsvr_replica" {
  default = "3"
	description = "Number of config servers to be used"
}

variable "tenancy_shardsvr" {
  default = "default"
	description = "Harware tenancy of the config server"
}

variable "volume_iops_shardsvr" {
	default = "2000"
	description = " IOPS for the aws ebs config server/s"
}

variable "volume_size_shardsvr" {
	default = "100"
	description = "EBS ssd io1 block size for the config server"
}

variable "instance_type_queryrouter" {
	default = "m4.large"
	description = "instance type of the config server"
}

variable "count_queryrouter" {
  default = "3"
	description = "Number of config servers to be used"
}

variable "tenancy_queryrouter" {
  default = "default"
	description = "Harware tenancy of the config server"
}

variable "volume_iops_queryrouter" {
	default = "2000"
	description = " IOPS for the aws ebs config server/s"
}

variable "volume_size_queryrouter" {
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
