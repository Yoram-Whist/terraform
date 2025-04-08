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

      # managed_scaling = {
      #   maximum_scaling_step_size = 1
      #   minimum_scaling_step_size = 1
      #   status                    = "ENABLED"
      #   target_capacity           = 60
      # }
    }
  }

  tags = local.common_tags
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.12.0"

  depends_on  = [module.db]
  name        = var.ecs_task_name
  cluster_arn = module.ecs_cluster.arn
  launch_type = var.instance_type

  cpu    = var.task_cpu_allocation
  memory = var.task_memory_allocation

  requires_compatibilities = [var.instance_type]
  container_definitions = {
    "${var.task_container_name}" = {
      cpu       = var.task_cpu_allocation
      memory    = var.task_memory_allocation
      essential = true
      image     = var.task_image
      port_mappings = [
        {
          name          = var.task_container_name
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
      container_name   = var.task_container_name
      container_port   = 80
    }
  }

  desired_count      = 6
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ecs_sg.id]

  tags = local.common_tags
}