# Reference https://github.com/cn-terraform/terraform-aws-ecs-service-autoscaling
#------------------------------------------------------------------------------
# AWS Auto Scaling - CloudWatch Alarm CPU High
#------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${terraform.workspace}-${var.service_name}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.max_cpu_evaluation_period
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.max_cpu_period
  statistic           = "Maximum"
  threshold           = var.max_cpu_threshold
  dimensions = {
    ClusterName = "${terraform.workspace}-${var.cluster_name}"
   ServiceName = "${terraform.workspace}-${var.service_name}-ecs-service"
  }
  alarm_actions = compact([
    aws_appautoscaling_policy.scale_up_policy.arn,
      var.sns_topic_arn != "" ? var.sns_topic_arn : ""
  ])
  tags = {
    Name        = "${terraform.workspace}-${var.service_name}-cpu-high"
    env         = "${terraform.workspace}"
  }
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - CloudWatch Alarm CPU Low
#------------------------------------------------------------------------------
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${terraform.workspace}-${var.service_name}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.min_cpu_evaluation_period
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.min_cpu_period
  statistic           = "Average"
  threshold           = var.min_cpu_threshold
  dimensions = {
     ClusterName = "${terraform.workspace}-${var.cluster_name}"
    ServiceName = "${terraform.workspace}-${var.service_name}-ecs-service"
  }
  alarm_actions = compact([
    aws_appautoscaling_policy.scale_down_policy.arn,
      var.sns_topic_arn != "" ? var.sns_topic_arn : ""
  ])
  tags = {
    Name        = "${terraform.workspace}-${var.service_name}-cpu-low"
    env         = "${terraform.workspace}"
  }
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Up Policy
#------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "scale_up_policy" {
  name               = "${terraform.workspace}-${var.service_name}-scale-up-policy"
  depends_on         = [aws_appautoscaling_target.scale_target]
  service_namespace  = "ecs"
  resource_id        = "service/${terraform.workspace}-${var.cluster_name}/${terraform.workspace}-${var.service_name}-ecs-service"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.cooldown
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Down Policy
#------------------------------------------------------------------------------
resource "aws_appautoscaling_policy" "scale_down_policy" {
  name               = "${terraform.workspace}-${var.service_name}-scale-down-policy"
  depends_on         = [aws_appautoscaling_target.scale_target]
  service_namespace  = "ecs"
  resource_id        = "service/${terraform.workspace}-${var.cluster_name}/${terraform.workspace}-${var.service_name}-ecs-service"
  scalable_dimension = "ecs:service:DesiredCount"
  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.cooldown
    metric_aggregation_type = "Maximum"
    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Target
#------------------------------------------------------------------------------
resource "aws_appautoscaling_target" "scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${terraform.workspace}-${var.cluster_name}/${terraform.workspace}-${var.service_name}-ecs-service"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.scale_target_min_capacity
  max_capacity       = var.scale_target_max_capacity
}