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

variable "cluster_name" {
  default = "ecs-cluster"
}
variable "target_group_name_login_backend" {
  default = "login-backend-tg"
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
variable "target_group_name_org_backend" {
  default = "org-backend-tg"
}
variable "target_group_name_reports_backend" {
  default = "reports-backend-tg"
}
variable "target_group_name_employee_mgmt_transaction" {
  default = "employee-mgmt-trans-backend-tg"
}
variable "target_group_name_employee_mgmt" {
  default = "employee-mgmt-tg"
}
variable "target_group_name_employee_exit_transaction_backend" {
  default = "employee-exit-trans-backend-tg"
}
variable "target_group_name_employee_exit_backend" {
  default = "employee-exit-backend-tg"
}
variable "target_group_name_ams_transaction" {
  default = "ams-transaction-tg"
}
variable "target_group_name_ams_control" {
  default = "ams-control-tg"
}
variable "target_group_name_ams_reports" {
  default = "ams-reports-tg"
}