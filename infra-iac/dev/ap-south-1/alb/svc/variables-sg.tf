

variable "egress_cidr" {
  default = "0.0.0.0/0"
}

variable "ingress_cidr" {
  default = "0.0.0.0/0"
}
variable "ingress_443" {
  default = 443
}
variable "ingress_80" {
  default = 80
}
variable "ingress_from" {
  default = 0
}

variable "ingress_to" {
  default = 65535
}
variable "egress_from" {
  default = 0
}

variable "egress_to" {
  default = 65535
}

variable "ingress_ssh" {
  default = 22
}
variable "cluster_name" {
  default = "ecs-cluster"
}

