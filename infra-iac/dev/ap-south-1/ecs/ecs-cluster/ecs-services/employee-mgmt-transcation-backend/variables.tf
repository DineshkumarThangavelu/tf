variable "cluster_name" {
  default = "ecs-cluster"
}

variable "aws_region" {
  default = "ap-south-1"
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
variable "service_name" {
  default = "employee-mgmt-transaction-backend"
}
variable "cluster_id" {
  description = "ID of the ECS Cluster"
  type        = string
}
variable "service_arn" {
  description = "arn of the employee mgmt transaction backend service"
  type        = string
}

