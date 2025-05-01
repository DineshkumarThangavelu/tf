terraform {
  backend "s3" {
    bucket  = "icomm-dev-mgmt-ap-south-1"
    key     = "aws/start/dev/ap-south-1/ec2/gitlab-runner/terraform.tfstate"
    encrypt = "true"
    region  = "ap-south-1"
  }
}
