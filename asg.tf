module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.2.0"
  # Autoscaling group
  name = var.asg_name

  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_size
  wait_for_capacity_timeout = 0
  health_check_type         = var.launch_type
  vpc_zone_identifier       = module.vpc.private_subnets

  # Launch template
  launch_template_name   = var.launch_template_name
  update_default_version = true

  image_id          = var.image_id
  instance_type     = var.instance_type
  ebs_optimized     = true
  enable_monitoring = true

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = var.instance_storage
        volume_type           = var.storage_type
      }
    }
  ]

  network_interfaces = [
    {
      delete_on_termination     = true
      description               = "eth0"
      device_index              = 0
      security_groups           = [module.ecs_service.security_group_id]
      sociate_public_ip_address = false # Disable auto-assign public IP
    }
  ]

  initial_lifecycle_hooks = [
    {
      name                 = var.asg_lifecycle_name
      default_result       = var.lifecycle_default_result
      heartbeat_timeout    = var.lifecycle_heartbeat_timeout
      lifecycle_transition = var.lifecycle_transition
    }
  ]

  # ECS Cluster association
  user_data = base64encode(templatefile("${path.module}/templates/ec2_asg_sh.tpl", {
    ecs_cluster_name = module.ecs_cluster.name # ecs.cluster_name
  }))

  iam_instance_profile_name = "ecsInstanceRole"

  tags = merge(local.common_tags,{
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  })

}


# CloudWatch alarm for scale up based on CPU utilization above 60%
resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization for scale-up"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  alarm_name          = "ecs_scale_up"
  comparison_operator = "GreaterThanThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = var.scale_up_treshold
  evaluation_periods  = var.evaluation_periods
  period              = var.scale_in_out_timeout # 5 minutes period
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = module.asg.autoscaling_group_name
  }
}

# CloudWatch alarm for scale down based on CPU utilization below 40%
resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for scale-down"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "ecs_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = var.scale_down_treshold
  evaluation_periods  = var.evaluation_periods
  period              = var.scale_in_out_timeout # 5 minutes period
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = module.asg.autoscaling_group_name
  }
}

# Autoscaling policy to add one instance if CPU utilization is high
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "ecs_scale_up"
  autoscaling_group_name = module.asg.autoscaling_group_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.increase_instances_amount
  cooldown               = var.cooldown
}

# Autoscaling policy to remove one instance if CPU utilization is low
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "ecs_scale_down"
  autoscaling_group_name = module.asg.autoscaling_group_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = var.decrease_instances_amount
  cooldown               = var.cooldown
}
