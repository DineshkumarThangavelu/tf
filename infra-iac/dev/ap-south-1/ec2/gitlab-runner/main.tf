data "aws_caller_identity" "current" {
}

data "aws_vpc" "vpc_id" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "ec2_subnet" {
  count             = length(var.azs)
  vpc_id            = data.aws_vpc.vpc_id.id
  availability_zone = element(var.azs, count.index)

  filter {
    name   = "tag:Name"
    values = [var.ec2_subnet]
  }
}

data "aws_iam_instance_profile" "iam_instance_profile" {
  name = var.iam_instance_profile
}
data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

