### other
creator = "Yoram"

### VPC
aws_region             = "us-west-1"
vpc_name               = "TF-Yoram"
vpc_cidr_block         = "10.0.0.0/16"
availability_zones     = ["us-west-1a", "us-west-1b"]
public_subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs   = ["10.0.3.0/24", "10.0.4.0/24"]
enable_vpn_gateway     = false
enable_nat_gateway     = true
single_nat_gateway     = false
one_nat_gateway_per_az = true

### Security Groups
alb_sg_name    = "ALB_SG"
ecs_sg_name    = "ECS_SG"
rds_sg_name    = "RDS_SG"
mysql_port     = 3306
http_port      = 80
tcp_protocol   = "tcp"
http_protocol  = "http"
all_cidr_block = ["0.0.0.0/0"]

### RDS
rds_engine                  = "mysql"
rds_db_name                 = "app_db"
rds_engine_version          = "8.0"
rds_engine_sub_version      = ".40"
rds_instance                = "db.t3.micro"
rds_storage_size            = 20
storage_type                = "gp3"
deletion_protection         = false
skip_final_snapshot         = true
rds_creds_secrets           = "rds-cred-tf"
manage_master_user_password = false
rds_multi_az                = true
create_db_subnet_group      = true
rds_backup_retention_period = 1
rds_backup_window           = "03:00-03:30"

### Application Load Balancer
alb_name           = "TF-ALB"
load_balancer_type = "application"
alb_cidr           = "0.0.0.0/0"

### S3
alb_bucket_name = "my-s3-bucket-for-alb-logs-yoram"

### Auto Scaling Group
asg_name                    = "TF-ASG"
alb_tg_name                 = "ecs_tg"
asg_max_size                = 4
asg_min_size                = 2
asg_desired_size            = 2
launch_template_name        = "ecs-app-asg"
image_id                    = "ami-0509eb4a380d8a316"
instance_type               = "c5.large"
instance_storage            = 30
asg_lifecycle_name          = "ecs-managed-draining-termination-hook"
lifecycle_default_result    = "CONTINUE"
lifecycle_heartbeat_timeout = 180
lifecycle_transition        = "autoscaling:EC2_INSTANCE_TERMINATING"
scale_up_treshold           = 60
scale_down_treshold         = 40
evaluation_periods          = 1
increase_instances_amount   = 1
decrease_instances_amount   = -1
cooldown                    = 120

### ECS
cluster_name                          = "tf-ecs-ec2"
default_capacity_provider_use_fargate = false
ecs_service_name                      = "app-svc"
max_scale_step_size                   = 1
min_scale_step_size                   = 1
managed_scaling_status                = "ENABLED"
target_capacity                       = 100
task_name                             = "python-task"
launch_type                           = "EC2"
task_cpu_allocation                   = 256
task_memory_allocation                = 512
task_image                            = "930354804502.dkr.ecr.us-west-1.amazonaws.com/yoram/python-app:latest"
desired_count                         = 6
autoscaling_max_capacity              = 10
autoscaling_min_capacity              = 6
autoscaling_service_cpu_target        = 60
scale_in_out_timeout                  = 300