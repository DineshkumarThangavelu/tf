provider "aws" {
  region = var.aws_region
}
data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "private" {
  count             = length(var.subnets.private)
  vpc_id            = data.aws_vpc.vpc_id.id
  availability_zone = element(var.azs, count.index)

  filter {
    name   = "tag:Name"
    values = var.subnets.private
  }
}

data "aws_ecs_cluster" "ecs" {
  cluster_name = "${terraform.workspace}-${var.cluster_name}"
}
data "aws_lb_target_group" "login_backend" {
  name = var.target_group_name_login_backend
}
data "aws_lb_target_group" "org_backend" {
  name = var.target_group_name_org_backend
}
data "aws_lb_target_group" "reports_backend" {
  name = var.target_group_name_reports_backend
}
data "aws_lb_target_group" "employee_mgmt_transaction" {
  name = var.target_group_name_employee_mgmt_transaction
}
data "aws_lb_target_group" "employee_mgmt" {
  name = var.target_group_name_employee_mgmt
}
data "aws_lb_target_group" "employee_exit_transaction_backend" {
  name = var.target_group_name_employee_exit_transaction_backend
}
data "aws_lb_target_group" "employee_exit" {
  name = var.target_group_name_employee_exit_backend
}
data "aws_lb_target_group" "ams_transaction" {
  name = var.target_group_name_ams_transaction
}
data "aws_lb_target_group" "ams_control" {
  name = var.target_group_name_ams_control
}
data "aws_lb_target_group" "ams_reports" {
  name = var.target_group_name_ams_reports 
}



module "Login_Services" {
  source      = "./login-backend"
  cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.login_backend.arn

}
module "Org_Services" {
  source = "./org-backend"
  cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.org_backend.arn

}
module "Reports_Services" {
  source = "./reports-backend"
  cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.reports_backend.arn

}
module "Emp_mgmt_Services" {
  source = "./employee-mgmt-backend"
   cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.employee_mgmt.arn


}
module "Emp_mgmt_trans_Services" {
  source = "./employee-mgmt-transcation-backend"
  cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.employee_mgmt_transaction.arn

}
module "Exit_Services" {
  source = "./employee-exit-backend"
  cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.employee_exit.arn


}
module "Exit_trans_Services" {
  source = "./employee-exit-transaction-backend"
   cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.employee_exit_transaction_backend.arn

}

module "Ams_trans_Services" {
  source = "./ams-transaction-backend"
   cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.ams_transaction.arn

}

module "Ams_control_Services" {
  source = "./ams-control-backend"
   cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.ams_control.arn

}

module "Ams_reports_Services" {
  source = "./ams-reports-backend"
   cluster_id  = data.aws_ecs_cluster.ecs.id
  service_arn = data.aws_lb_target_group.ams_reports.arn

}
