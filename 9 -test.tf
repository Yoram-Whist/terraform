module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name = "tf-ecs-ec2"
  # Capacity provider - autoscaling groups
  default_capacity_provider_use_fargate = false

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  autoscaling_capacity_providers = {
    one = {
      auto_scaling_group_arn         = module.asg.autoscaling_group_arn

      managed_scaling = {
        maximum_scaling_step_size = 1
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 60
      }
    }
  }

  tags = local.common_tags
}

module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "example"
  cluster_arn = module.ecs_cluster.arn
  launch_type = "EC2"

  cpu    = 1024
  memory = 4096

  # Container definition(s)
  container_definitions = {
    ecs-sample = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = "930354804502.dkr.ecr.us-west-1.amazonaws.com/yoram/python-app:latest"
      port_mappings = [
        {
          name          = "ecs-sample"
          containerPort = 80
          protocol      = "tcp"
          appProtocol  = "http"
        }
      ]

      enable_cloudwatch_logging = true
      memory_reservation = 100
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["ex_ecs"].arn
      container_name   = "ecs-sample"
      container_port   = 80
    }
  }

  subnet_ids = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ecs_sg.id]

  tags = local.common_tags
}

# module "ecs_container_definition" {
#   source = "terraform-aws-modules/ecs/aws//modules/container-definition"

#   name      = "example"
#   cpu       = 512
#   memory    = 1024
#   essential = true
#   image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
#   port_mappings = [
#     {
#       name          = "ecs-sample"
#       containerPort = 80
#       protocol      = "tcp"
#     }
#   ]

#   # Example image used requires access to write to root filesystem
#   readonly_root_filesystem = false

#   memory_reservation = 100

#   tags = local.common_tags
# }