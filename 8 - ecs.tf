
# #  "930354804502.dkr.ecr.us-west-1.amazonaws.com/yoram/python-app:latest"
# resource "aws_ecs_task_definition" "yoram-tf-task" {
#   family             = "yoram-tf-task"
#   execution_role_arn = "arn:aws:iam::930354804502:role/ecsTaskExecutionRole"
#   network_mode       = "awsvpc"
#   cpu                = 512
#   memory             = 1024
#   container_definitions = jsonencode([
#     {
#       name   = "python-container"
#       image  = "930354804502.dkr.ecr.us-west-1.amazonaws.com/yoram/python-app:latest"
#       cpu    = 512
#       memory = 1024
#       portMappings = [
#         {
#           name          = "web"
#           containerPort = 80
#           hostPort      = 80
#           protocol      = "tcp"
#           appProtocol   = "http"
#         }
#       ]
#       essential = true

#     }
#   ])
#   runtime_platform {
#     cpu_architecture        = "X86_64"
#     operating_system_family = "LINUX"
#   }
# }

# # ECS Service with Auto Scaling
# resource "aws_ecs_service" "ecs_service" {
#   name            = "ecs-service"
#   cluster         = module.ecs.cluster_id # Reference to the ECS cluster
#   task_definition = aws_ecs_task_definition.yoram-tf-task.arn
#   desired_count   = 6 # Minimum number of tasks to run

#   launch_type = "EC2" # Using EC2 for the task launch type (you can use Fargate too if needed)

#   load_balancer {
#     target_group_arn = aws_lb_target_group.alb_tg.arn
#     container_name   = "python-container"
#     container_port   = 80
#   }
# }

# module "ecs" {
#   source = "terraform-aws-modules/ecs/aws"

#   cluster_name = "tf-yoram-ecs"

#   cluster_configuration = {
#     execute_command_configuration = {
#       logging = "OVERRIDE"
#       log_configuration = {
#         cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
#       }
#     }
#   }

#   # Capacity provider - autoscaling groups
#   default_capacity_provider_use_fargate = false

#   # Autoscaling capacity provider (using ASG)
#   autoscaling_capacity_providers = {
#     one = {
#       auto_scaling_group_arn = module.asg.autoscaling_group_arn

#       managed_scaling = {
#         maximum_scaling_step_size = 2 
#         minimum_scaling_step_size = 1 
#         status                    = "ENABLED"
#         target_capacity           = 60 
#         scale_in_cooldown         = 300
#         scale_out_cooldown        = 300
#       }

#       # Adjust the scale-out and scale-in behavior based on the percentage
#       # scaling_policies = {
#       #   scale_in = {
#       #     threshold          = 40 
#       #     adjustment_type    = "ChangeInCapacity"
#       #     cooldown           = 300 
#       #     scaling_adjustment = -1 
#       #   }
#       #   scale_out = {
#       #     threshold          = 60 
#       #     adjustment_type    = "ChangeInCapacity"
#       #     cooldown           = 300 
#       #     scaling_adjustment = 1   
#       #   }
#       # }
#     }
#   }
# }