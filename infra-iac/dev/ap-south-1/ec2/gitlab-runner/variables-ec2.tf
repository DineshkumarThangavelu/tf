
variable "instance_name" {
  default = "gitlab-runner"
}

variable "key_name" {
  default = "dev-ap-south1-20241217"
}

variable "ec2_subnet" {
  default = "Icomm-ClassicTU-vpc-subnet-private1-ap-south-1a"
}

variable "instance_type" {
  default = "t3a.small" #EX: t3a.medium
}

variable "ebsvolume_size" {
  default = "30"
}

variable "ebsvolume_type" {
  default = "gp3"
}

variable "iam_instance_profile" {
  default = "gitlab-runner-role"
}

variable "vpc_name" {
  default = "Icomm-ClassicTU-vpc-vpc"
}

variable "azs" {
  default = [
    "ap-south-1a", #EX: us-east-1a
  ]
}

variable "aws_region" {
  default = "ap-south-1" #EX:us-east-1
}
variable "ec2_instances" {
  default = 1
}


