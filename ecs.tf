module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.12.0"

  cluster_name = var.cluster_name
  # Capacity provider - autoscaling groups
  default_capacity_provider_use_fargate = false

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs"
      }
    }
  }

  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn = module.asg.autoscaling_group_arn

      managed_scaling = {
        maximum_scaling_step_size = var.max_scale_step_size
        minimum_scaling_step_size = var.min_scale_step_size
        status                    = var.managed_scaling_status
        target_capacity           = var.target_capacity
        warm_up_time              = 300
      }
    }
  }

  tags = local.common_tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.12.0"

  depends_on  = [module.db] # waiting for the db to initialize before creating tasks
  name        = var.ecs_service_name
  cluster_arn = module.ecs_cluster.arn
  launch_type = var.launch_type

  cpu    = var.task_cpu_allocation
  memory = var.task_memory_allocation

  requires_compatibilities = [var.launch_type]
  container_definitions = {
    "${var.task_name}" = {
      cpu       = var.task_cpu_allocation
      memory    = var.task_memory_allocation
      essential = true
      image     = var.task_image
      port_mappings = [
        {
          name          = var.task_name
          containerPort = var.http_port
          protocol      = var.tcp_proctocol
          appProtocol   = var.http_protocol
        }
      ]
      enable_cloudwatch_logging = true
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups[var.alb_tg_name].arn
      container_name   = var.task_name
      container_port   = var.http_port
    }
  }

  desired_count            = var.desired_count
  autoscaling_max_capacity = 10
  autoscaling_min_capacity = 6
  autoscaling_policies = {
    "cpu" = {
      "policy_type" = "TargetTrackingScaling"
      "target_tracking_scaling_policy_configuration" = {
        "target_value" = 60 # Set target CPU utilization to 60%
        "predefined_metric_specification" = {
          "predefined_metric_type" = "ECSServiceAverageCPUUtilization"
        }
        "scale_in_cooldown"  = 300 # Optional: Set cooldown period for scaling in (5 minutes)
        "scale_out_cooldown" = 300 # Optional: Set cooldown period for scaling out (5 minutes)
      }
    }
  }


  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ecs_sg.id]

  tags = local.common_tags
}