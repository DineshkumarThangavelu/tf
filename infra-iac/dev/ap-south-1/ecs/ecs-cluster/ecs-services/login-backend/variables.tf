variable "cluster_name" {
  default = "ecs-cluster"
}

variable "aws_region" {
  default = "ap-south-1"
}
variable "cluster_id" {
  description = "ID of the ECS Cluster"
  type        = string
}
variable "service_arn" {
  description = "arn of the login backend service"
  type        = string
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
  default = "login-backend"
}
variable "target_group_name_login_backend" {
  default = "login-backend-tg"
}

