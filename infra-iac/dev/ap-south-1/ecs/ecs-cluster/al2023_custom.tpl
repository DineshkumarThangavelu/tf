#!/bin/bash
set -ex
sudo dnf install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo mkdir -p /etc/ecs
sudo echo ECS_ENABLE_TASK_IAM_ROLE=true > /etc/ecs/ecs.config
sudo echo ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true >> /etc/ecs/ecs.config
sudo echo ECS_LOGFILE=/log/ecs-agent.log >> /etc/ecs/ecs.config
sudo echo ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"awslogs\"] >> /etc/ecs/ecs.config
sudo echo ECS_LOGLEVEL=info >> /etc/ecs/ecs.config
sudo echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
#sudo docker container rm $(docker ps -aq) |true
sudo docker pull amazon/amazon-ecs-agent:${ecs_agent_version}
sudo docker run --name ecs-agent --detach=true --restart=always --volume=/var/run:/var/run --volume=/var/log/ecs/:/log:Z --volume=/etc/ecs:/etc/ecs --net=host --env-file=/etc/ecs/ecs.config  --volume=/var/lib/ecs/data:/data:Z --privileged amazon/amazon-ecs-agent:${ecs_agent_version}