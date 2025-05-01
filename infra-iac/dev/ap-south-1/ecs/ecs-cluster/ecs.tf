# ECS cluster
resource "aws_ecs_cluster" "ecs" {
  name = "${terraform.workspace}-${var.cluster_name}"
}
resource "aws_security_group" "sg" {
  name        = "${terraform.workspace}-${var.cluster_name}-sg"
  description = "${terraform.workspace}-${var.cluster_name}-sg"
  vpc_id      = data.aws_vpc.vpc_id.id

  tags = {
    Name = "${terraform.workspace}-${var.cluster_name}-sg"
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

  cidr_ipv4 = var.egress_cidr
  #from_port   = var.egress_from
  ip_protocol = "-1" # semantically equivalent to all ports
  #to_port     = var.egress_to
}


resource "aws_launch_template" "as_template" {
  name          = "ecs_cluster"
  image_id      = data.aws_ami.amazon-linux-2023.id
  instance_type = var.ec2_instance_type
  user_data     = base64encode(templatefile("${path.module}/al2023_custom.tpl", {cluster_name = aws_ecs_cluster.ecs.name, ecs_agent_version = var.ecs_agent_version}))
  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size = var.ebs_voulume_size
      volume_type = var.volume_type
      encrypted   = true
    }
  }
  iam_instance_profile {
    name = data.aws_iam_instance_profile.iam_instance_profile.name
  }
  key_name = var.key_name
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ecs-node"
    }
  }
  vpc_security_group_ids = [aws_security_group.sg.id]
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider
# resource "aws_autoscaling_group" "asg" {
#   name                      = "${terraform.workspace}-${var.cluster_name}-asg"
#   max_size                  = 5
#   min_size                  = 0
#   desired_capacity          = 1
#   force_delete              = true
#   launch_template {
#     id      = aws_launch_template.as_template.id
#     version = "$Latest"
#   }
#   vpc_zone_identifier       = flatten([data.aws_subnet.private.*.id])

#   # Required for  managed_termination_protection = "ENABLED"
#   protect_from_scale_in = true
#   default_cooldown = 300

#   tag {
#     key                 = "AmazonECSManaged"
#     value               = true
#     propagate_at_launch = true
#   }
# }
#https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cluster-auto-scaling.html
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider.html
#https://github.com/terraform-aws-modules/terraform-aws-ecs/blob/v5.12.0/examples/ec2-autoscaling/main.tf
#to view the created provider use aws cli to :::: aws ecs describe-capacity-providers ::::

#ECS Capacity Provider
# resource "aws_ecs_capacity_provider" "ecs_cp" {
#   name = "${terraform.workspace}-${var.cluster_name}-cp"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
#     managed_termination_protection = "ENABLED"
#     managed_draining = "ENABLED"

#     managed_scaling {
#       maximum_scaling_step_size = 100
#       minimum_scaling_step_size = 1
#       status                    = "ENABLED"
#       target_capacity           = 100
#     }
#   }
# }

#Associate Capacity Provider with Cluster
# resource "aws_ecs_cluster_capacity_providers" "ecs_cp" {
#   cluster_name = aws_ecs_cluster.ecs.name

#   capacity_providers = [aws_ecs_capacity_provider.ecs_cp.name]

#   default_capacity_provider_strategy {
#     base              = 0
#     weight            = 1
#     capacity_provider = aws_ecs_capacity_provider.ecs_cp.name
#   }
#   depends_on = [aws_ecs_cluster.ecs]
# }



# allow ecs inter cluster communication
resource "aws_security_group_rule" "allow_ecs_cluster_security" {
  type                     = "ingress"
  security_group_id        = aws_security_group.sg.id
  source_security_group_id = aws_security_group.sg.id
  from_port                = var.ingress_from
  protocol                 = "tcp"
  to_port                  = var.ingress_to
}
