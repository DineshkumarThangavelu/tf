### KT notes

IAC code:
--------
branch : master
https://github.com/balajimaniv/infra-iac.git


Autoscaling
------------

https://github.com/cn-terraform/terraform-aws-ecs-service-autoscaling/blob/main/main.tf
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy



terraform
---------
dev/ap-south-1/s3/icomm-dev-mgmt-ap-south-1
dev/ap-south-1/keys -- keep it in s3 icomm-dev-mgmt-ap-south-1/pem
dev/ap-south-1/iam/gitlab-runner-role
dev/ap-south-1/iam/ecs-instance-role
dev/ap-south-1/ec2/gitlab-runner
dev/ap-south-1/ecs/ecs-cluster
dev/ap-south-1/alb/svc
dev/ap-south-1/ecs/ecs-cluster/ecs-services
dev/ap-south-1/ecs/ecs-cluster/ecs-services/login-backend
dev/ap-south-1/ecs/ecs-cluster/ecs-services/org-backend   -- you have to write
dev/ap-south-1/alb/svc/alb.tf  -- this already done for org-backend



terraform commands
------------------------
terraform init
terraform workspace new dev
terraform workspace select dev
terraform plan -out=tfplan
terraform apply --auto-approve tfplan
terraform plan -destroy
terraform apply -destroy

Gitlab ci pipeline
https://fhrgitrepo.formulahr.co.in/saas/classic-tech-upgrade-login-backend.git
branch: feature-added-dockerfile

https://fhrgitrepo.formulahr.co.in/saas/classic-tech-upgrade-login-backend/-/blob/feature-added-dockerfile/.gitlab-ci.yml?ref_type=heads


