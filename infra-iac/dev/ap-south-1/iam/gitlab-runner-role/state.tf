terraform {
  backend "s3" {
    bucket  = "icomm-dev-mgmt-ap-south-1"
    key     = "aws/dev/runner-instance-role/terraform.tfstate"
    encrypt = "true"
    region  = "ap-south-1" #EX: us-east-1aws
  }
}
