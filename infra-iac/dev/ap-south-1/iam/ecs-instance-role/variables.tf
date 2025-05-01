variable "role_name" {
  default = "ecs-instance-role"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "iam_policy_ecs_arn" {
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
variable "iam_policy_efs_arn" {
  default = "arn:aws:iam::aws:policy/AmazonElasticFileSystemReadOnlyAccess"
}
variable "iam_policy_ssm_arn" {
  default = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
variable "iam_policy_ecr_arn" {
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

