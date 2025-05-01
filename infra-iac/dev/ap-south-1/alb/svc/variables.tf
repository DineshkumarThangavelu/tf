
variable "alb_name" {
  default = "svc"
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
      "Icomm-ClassicTU-vpc-subnet-public1-ap-south-1a",
      "Icomm-ClassicTU-vpc-subnet-public2-ap-south-1b"
    ]
  }
}

variable "aws_region" {
  default = "ap-south-1" #EX:us-east-1
}
variable "idle_timeout" {
  default = 300 # 5 minutes default 60sec
}

variable "target_group_name_login_backend" {
  default = "login-backend-tg"
}
variable "target_group_name_org_backend" {
  default = "org-backend-tg"
}
variable "target_group_name_employee_mgmt" {
  default = "employee-mgmt-tg"
}
variable "target_group_name_employee_mgmt_transaction" {
  default = "employee-mgmt-trans-backend-tg"
}
variable "target_group_name_employee_exit" {
  default = "employee-exit-backend-tg"
}
variable "target_group_name_employee_exit_transaction" {
  default = "employee-exit-trans-backend-tg"
}
variable "target_group_name_reports_backend" {
  default = "reports-backend-tg"
}
variable "cert_arn" {
  default = "arn:aws:acm:ap-south-1:266735807609:certificate/844809d3-ae84-49cf-abc8-4ec7cab32e48"
}
