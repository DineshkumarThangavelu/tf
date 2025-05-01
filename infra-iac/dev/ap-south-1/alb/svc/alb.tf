resource "aws_security_group" "sg" {
  name        = "${terraform.workspace}-${var.alb_name}-sg"
  description = "${terraform.workspace}-${var.alb_name}-sg"
  vpc_id      = data.aws_vpc.vpc_id.id

  tags = {
    Name = "${terraform.workspace}-${var.alb_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_443_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.ingress_cidr
  from_port         = var.ingress_443
  ip_protocol       = "tcp"
  to_port           = var.ingress_443
}
resource "aws_vpc_security_group_ingress_rule" "allow_80_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.ingress_cidr
  from_port         = var.ingress_80
  ip_protocol       = "tcp"
  to_port           = var.ingress_80
}
resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4   = var.egress_cidr
  ip_protocol = "-1" # semantically equivalent to all ports
}

resource "aws_lb" "alb" {
  name               = "${terraform.workspace}-${var.alb_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = flatten([data.aws_subnet.public.*.id])
  idle_timeout       = var.idle_timeout
tags = {
    Name             = "${terraform.workspace}-${var.alb_name}"
    env              = "${terraform.workspace}"
    purpose          = "Expose backend services"
  }
}
resource "aws_lb_listener" "front_end_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   =  var.cert_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "SVC alb"
      status_code  = "200"
    }
  }
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "SVC alb"
      status_code  = "200"
    }
  }
}

/**
login backend service - start
*/

resource "aws_lb_target_group" "login_backend" {
  name     = var.target_group_name_login_backend
  port     = 1
  protocol = "HTTP"
  vpc_id   =  data.aws_vpc.vpc_id.id
  health_check {
    protocol = "HTTP"
    path     =  "/api/healthcheck"
  }
}

resource "aws_lb_listener_rule" "login_backend" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.login_backend.arn
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}
/**
login backend service - stop
*/

/**
org backend service - start
*/
resource "aws_lb_target_group" "org_backend" {
  name     = var.target_group_name_org_backend
  port     = 1
  protocol = "HTTP"
  vpc_id   =  data.aws_vpc.vpc_id.id
  health_check {
    protocol = "HTTP"
    path     =  "/api/org/healthcheck"
  }
}
resource "aws_lb_listener_rule" "org_backend" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.org_backend.arn
  }

  condition {
    path_pattern {
      values = ["/api/org/*"]
    }
  }
}
/**
org backend service - stop
*/

/**
Employee Mangement service - start
*/ 
resource "aws_lb_target_group" "employee_mgmt" {
  name     = var.target_group_name_employee_mgmt
  port     = 1
  protocol = "HTTP"
  vpc_id   =  data.aws_vpc.vpc_id.id
  health_check {
    protocol = "HTTP"
    path     =  "/api/empmgt/healthcheck"
  }
}
resource "aws_lb_listener_rule" "employee_mgmt" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.employee_mgmt.arn
  }

  condition {
    path_pattern {
      values = ["/api/empmgt/*"]
    }
  }
}
/**
Employee Mangement service - stop
*/ 

/**
Employee Management Transcation backend service - start
*/
resource "aws_lb_target_group" "employee_mgmt_transaction" {
  name     = var.target_group_name_employee_mgmt_transaction
  port     = 1
  protocol = "HTTP"
  vpc_id   =  data.aws_vpc.vpc_id.id
  health_check {
    protocol = "HTTP"
    path     =  "/api/empmgttrans/healthcheck"
  }
}
resource "aws_lb_listener_rule" "employee_mgmt_transaction" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 4
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.employee_mgmt_transaction.arn
  }

  condition {
    path_pattern {
      values = ["/api/empmgttrans/*"]
    }
  }
}
/**
Employee Management Transcation backend service - stop
*/

/**
Employee exit backend service - start
*/
resource "aws_lb_target_group" "employee_exit" {
  name     = var.target_group_name_employee_exit
  port     = 1
  protocol = "HTTP"
  vpc_id   =  data.aws_vpc.vpc_id.id
  health_check {
    protocol = "HTTP"
    path     =  "/api/empexit/healthcheck"
  }
}
resource "aws_lb_listener_rule" "employee_exit" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 5
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.employee_exit.arn
  }

  condition {
    path_pattern {
      values = ["/api/empexit/*"]
    }
  }
}
/**
Employee exit backend service - stop
*/
/**
Employee exit transaction backend service - start
*/
resource "aws_lb_target_group" "employee_exit_transaction" {
  name     = var.target_group_name_employee_exit_transaction
  port     = 1
  protocol = "HTTP"
  vpc_id   =  data.aws_vpc.vpc_id.id
  health_check {
    protocol = "HTTP"
    path     =  "/api/empexittrans/healthcheck"
  }
}
resource "aws_lb_listener_rule" "employee_exit_transaction" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 6
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.employee_exit_transaction.arn
  }

  condition {
    path_pattern {
      values = ["/api/empexittrans/*"]
    }
  }
}
/**
Employee exit transaction backend service - stop
*/

/**
Reports backend service -start
*/
resource "aws_lb_target_group" "reports_backend" {
  name     = var.target_group_name_reports_backend
  port     = 1
  protocol = "HTTP"
  vpc_id   =  data.aws_vpc.vpc_id.id
  health_check {
    protocol = "HTTP"
    path     =  "/api/empmgtreports/healthcheck"
  }
}
resource "aws_lb_listener_rule" "reports_backend" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 7
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.reports_backend.arn
  }

  condition {
    path_pattern {
      values = ["/api/empmgtreports/*"]
    }
  }
}

/**
Reports backend service -stop
*/

# allow alb to ecs cluster
resource "aws_security_group_rule" "allow_ecs_cluster_security" {
  type                             = "ingress"
  security_group_id                = data.aws_security_group.ecs_sg.id
  source_security_group_id         = aws_security_group.sg.id
  from_port                        = var.ingress_from
  protocol                         = "tcp"
  to_port                          = var.ingress_to
}

