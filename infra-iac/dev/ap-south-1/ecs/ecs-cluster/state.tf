# terraform {
#   backend "s3" {
#     bucket  = "icomm-dev-mgmt-ap-south-1"
#     key     = "aws/dev/ecs/ecs-cluster/terraform.tfstate"
#     encrypt = "true"
#     region  = "ap-south-1" #EX: us-east-1
#   }
# }
terraform {
  backend "local" {
    path = "./terraform.tfstate" 
  }
}
