### Other
variable "creator" {
  description = "The user who created the env, inserted in tags"
  type        = string
}

### VPC
variable "aws_region" {
  description = "Region to use for AWS resources"
  type        = string
}

variable "vpc_name" {
  description = "The name of the vpc"
  type        = string
}

variable "vpc_cidr_block" {
  description = "Base CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use in the specified region"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "enable_vpn_gateway" {
  description = "vpn gateway - not needed"
  type        = bool
}

variable "enable_nat_gateway" {
  description = "need for the private instances"
  type        = bool
}

variable "single_nat_gateway" {
  description = "enable nat for each private subnet"
  type        = bool
}

variable "one_nat_gateway_per_az" {
  description = "enable nat for each private availability"
  type        = bool
}

### Security Groups 

variable "alb_sg_name" {
  description = "The name of the alb sg"
  type        = string
}

variable "ecs_sg_name" {
  description = "The name of the ecs sg"
  type        = string
}

variable "rds_sg_name" {
  description = "The name of the rds sg"
  type        = string
}

variable "mysql_port" {
  description = "mysql connection port"
  type        = number
}

variable "http_port" {
  description = "port 80 for http connection"
  type        = number
}

variable "tcp_protocol" {
  description = "tcp protocol"
  type        = string
}

variable "http_protocol" {
  description = "http protocol"
  type        = string
}

variable "all_cidr_block" {
  description = "all cidr block"
  type        = list(string)
}

### RDS

variable "rds_engine" {
  description = "using the mysql engine"
  type        = string
}

variable "rds_db_name" {
  description = "name of the db created inside the rds"
  type        = string
}

variable "rds_engine_version" {
  description = "mysql enging version"
  type        = string
}

variable "rds_engine_sub_version" {
  description = "mysql minor engine version"
  type        = string
}

variable "rds_creds_secrets" {
  description = "RDS Secret name in aws secrets manager"
  type        = string
}

variable "manage_master_user_password" {
  description = "should the module manage the password"
  type        = string
}

variable "rds_multi_az" {
  description = "deploy in multiple availability zones"
  type        = bool
}

variable "create_db_subnet_group" {
  description = "creates a subnet group for the rds"
  type        = bool
}

variable "rds_instance" {
  description = "instance of the database"
  type        = string
}

variable "rds_storage_size" {
  description = "database allocated storage"
  type        = number
}

variable "storage_type" {
  description = "ssd storage for the ALL instances"
  type        = string
}

variable "deletion_protection" {
  description = "allows to delete the rds with terraform destroy"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "not creating a snapshop before deleting"
  type        = bool
}

### ALB

variable "alb_name" {
  description = "alb name"
  type        = string
}

variable "load_balancer_type" {
  description = "application load balancer"
  type        = string
}

variable "alb_cidr" {
  description = "load balancer ipv4 cidr block"
  type        = string
}

### Auto Scaling Group

variable "asg_name" {
  description = "auto scaling group name"
  type        = string
}

variable "alb_tg_name" {
  description = "load balancer target group name"
  type        = string
}

variable "asg_max_size" {
  description = "max amount of EC2s "
  type        = number
}

variable "asg_min_size" {
  description = "min amount of EC2s"
  type        = number
}

variable "asg_desired_size" {
  description = "desired amount of EC2s"
  type        = number
}

variable "launch_template_name" {
  description = "name of the asg launch template"
  type        = string
}

variable "image_id" {
  description = "The id of the machine image (AMI) to use for the server."
  type        = string
  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "instance_type" {
  description = "value"
  type        = string
}

variable "instance_storage" {
  description = "amount of storage allocated to the instace"
  type        = number
}

variable "asg_lifecycle_name" {
  description = "lifecycle hook name"
  type        = string
}

variable "lifecycle_default_result" {
  description = "The action the Auto Scaling group takes when the lifecycle hook timeout elapses or if an unexpected failure occurs."
  type        = string
}

variable "lifecycle_heartbeat_timeout" {
  description = "The amount of time, in seconds, for the instances to remain in wait state."
  type        = number
}

variable "lifecycle_transition" {
  description = "You can perform custom actions as EC2 Auto Scaling launches or terminates instances."
  type        = string
}

variable "scale_up_treshold" {
  description = "cpu avg usage before scaling up"
  type        = number
}

variable "scale_down_treshold" {
  description = "cpu avg usage before scaling down"
  type        = number
}

variable "evaluation_periods" {
  description = "how many times to occur before scaling up or down"
  type        = number
}

variable "increase_instances_amount" {
  description = "how many instances to create when scaling up"
  type        = number
}

variable "decrease_instances_amount" {
  description = "how many instances to terminate when scaling down"
  type        = number
}

variable "cooldown" {
  description = "how long to wait before each scale"
  type        = number
}

### ECS

variable "cluster_name" {
  description = "name of the ECS cluster"
  type        = string
}

variable "default_capacity_provider_use_fargate" {
  description = "enable if using fargates"
  type        = bool
}

variable "ecs_service_name" {
  description = "name of the ECS service"
  type        = string
}

variable "max_scale_step_size" {
  description = "max scaling step size"
  type        = number
}

variable "min_scale_step_size" {
  description = "min scaling step size"
  type        = number
}

variable "managed_scaling_status" {
  description = "on or off managed scaling"
  type        = string
}

variable "target_capacity" {
  description = "ecs target capacity desired"
  type        = number
}

variable "task_name" {
  description = "name of the ECS task"
  type        = string
}

variable "launch_type" {
  description = "EC2 machine for the type"
  type        = string
}

variable "task_cpu_allocation" {
  description = "how much cpu to allow the task to use"
  type        = number
}

variable "task_memory_allocation" {
  description = "how much ram memory to allow the task to use"
  type        = number
}

variable "task_image" {
  description = "python app as the base image for the tasks"
  type        = string
}

variable "desired_count" {
  description = "amount of desired tasks the service runs"
  type        = number
}

variable "autoscaling_max_capacity" {
  description = "max amount of running tasks in the service"
  type        = number
}

variable "autoscaling_min_capacity" {
  description = "min amount of running tasks in the service"
  type        = number
}

variable "autoscaling_service_cpu_target" {
  description = "the cou target value to add more services"
  type        = number
}

variable "scale_in_out_timeout" {
  description = "how long to wait before to scale in or down services"
  type        = number
}