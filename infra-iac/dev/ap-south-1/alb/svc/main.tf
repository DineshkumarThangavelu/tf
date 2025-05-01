data "aws_caller_identity" "current" {
}

data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "public" {
  count             = length(var.subnets.public)
  vpc_id            = data.aws_vpc.vpc_id.id
  availability_zone = element(var.azs, count.index)

  filter {
    name   = "tag:Name"
    values = var.subnets.public
  }
}

data "aws_security_group" "ecs_sg" {
  name = "${terraform.workspace}-${var.cluster_name}-sg"
}


