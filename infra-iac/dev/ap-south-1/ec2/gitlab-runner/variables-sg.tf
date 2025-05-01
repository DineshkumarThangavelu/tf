

variable "egress_cidr" {
  default = "0.0.0.0/0"
}

variable "ingress_vpc_cidr" {
  default = "172.16.0.0/16"
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

