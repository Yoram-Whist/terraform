module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.12.0"

  cluster_name = var.cluster_name
  # Capacity provider - using ec2's
  default_capacity_provider_use_fargate = var.default_capacity_provider_use_fargate

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
        instance_warmup_period    = var.scale_in_out_timeout
      }
    }
  }



  tags = local.common_tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.12.0"

  # depends_on  = [module.db] # waiting for the db to initialize before creating tasks
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
          protocol      = var.tcp_protocol
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
  autoscaling_max_capacity = var.autoscaling_max_capacity
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_policies = {
    "cpu" = {
      "policy_type" = "TargetTrackingScaling"
      "target_tracking_scaling_policy_configuration" = {
        "target_value" = var.autoscaling_service_cpu_target
        "predefined_metric_specification" = {
          "predefined_metric_type" = "ECSServiceAverageCPUUtilization"
        }
        "scale_in_cooldown"  = var.scale_in_out_timeout
        "scale_out_cooldown" = var.scale_in_out_timeout
      }
    }
  }

  subnet_ids          = module.vpc.private_subnets
  security_group_name = var.ecs_sg_name
  security_group_tags = local.common_tags
  security_group_rules = {
    alb_ingress_3000 = {
      type                     = "ingress"
      from_port                = var.http_port
      to_port                  = var.http_port
      protocol                 = var.tcp_protocol
      source_security_group_id = module.alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.all_cidr_block
    }
  }

  tags = local.common_tags
}