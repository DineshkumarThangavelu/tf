resource "aws_security_group" "sg" {
  name        = "${var.instance_name}-sg"
  description = "${var.instance_name}-sg"
  vpc_id      = data.aws_vpc.vpc_id.id

  tags = {
    Name = "${var.instance_name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = var.ingress_vpc_cidr
  from_port         = var.ingress_ssh
  ip_protocol       = "tcp"
  to_port           = var.ingress_ssh
}
resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.sg.id

  cidr_ipv4   = var.egress_cidr
  from_port   = var.egress_from
  ip_protocol = "-1" # semantically equivalent to all ports
  to_port     = var.egress_to
}

resource "aws_instance" "ec2" {
  ami                = data.aws_ami.amzn-linux-2023-ami.id
  instance_type      = var.instance_type
  subnet_id          = element(data.aws_subnet.ec2_subnet.*.id, count.index)
  availability_zone  = element(var.azs, count.index)
  associate_public_ip_address = false
  key_name           = var.key_name
  count              = var.ec2_instances
  vpc_security_group_ids = [aws_security_group.sg.id]
  iam_instance_profile  = data.aws_iam_instance_profile.iam_instance_profile.name
  user_data                 = base64encode(templatefile("${path.module}/al2023_custom.tpl", {instance_name = var.instance_name}))
  root_block_device {
    volume_size = var.ebsvolume_size
    volume_type = var.ebsvolume_type
    encrypted   = true
    tags = {
      Name                    = "${var.instance_name}${count.index + 1}-root"
      env                     = "${terraform.workspace}"
    }

  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [user_data,ebs_block_device,associate_public_ip_address]
  }

  tags = {
          Name = "${var.instance_name}${count.index + 1}"
          env =  "${terraform.workspace}"
  }
}
