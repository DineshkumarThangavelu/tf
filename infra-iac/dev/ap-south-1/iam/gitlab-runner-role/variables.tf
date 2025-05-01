variable "role_name" {
  default = "gitlab-runner-role"
}

variable "aws_region" {
  default = "ap-south-1"
}
variable "ssm_access_policy_name" {
  default = "AmazonSSMManagedInstanceCore"
}
variable "s3_fullaccess_policy_name" {
  default = "AmazonS3FullAccess"
}
