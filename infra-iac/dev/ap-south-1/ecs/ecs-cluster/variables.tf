variable "cluster_name" {
  default = "ecs-cluster"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "ebs_voulume_size" {
  type = number
  default = 50 # 50 GB storage of gp2 type.
}
variable "volume_type" {
  default = "gp3"
}
variable "device_name" {
  default = "/dev/sdg"
}
variable "ecs_agent_version" {
  default = "latest"
}
variable "vpc_name" {
  default = "classic-tech-upgrade-vpc"
}
variable "azs" {
  default = [
    "ap-south-1a",
    "ap-south-1b"
  ]
}
variable "subnets" {
  type = map(list(string))
  default = {
    private = [
      "Icomm-ClassicTU-vpc-subnet-private1-ap-south-1a",
      "Icomm-ClassicTU-vpc-subnet-private2-ap-south-1b"
    ],
    public = [
      "subnetA",
      "subnetB"
    ]
  }
}
variable "iam_instance_profile" {
  default = "ecs-instance-role"
}
variable "key_name" {
  default = "dev-ap-south1-20241217"
}
variable "ec2_instance_type" {
  default = "t2.micro"
}
