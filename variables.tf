### VPC

variable "aws_region" {
  description = "Region to use for AWS resources"
  type        = string
  default     = "us-west-1"
}

variable "vpc_name" {
  description = "The name of the vpc"
  type        = string
  default     = "TF-Yoram"
}

variable "vpc_cidr_block" {
  description = "Base CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use in the specified region"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1b"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "enable_vpn_gateway" {
  description = "vpn gateway - not needed"
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "need for the private instances"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "enable nat for each private subnet"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "enable nat for each private availability"
  type        = bool
  default     = true
}

### Security Groups 

variable "alb_sg_name" {
  description = "The name of the alb sg"
  type        = string
  default     = "ALB_SG"
}

variable "ecs_sg_name" {
  description = "The name of the ecs sg"
  type        = string
  default     = "ECS_SG"
}

variable "rds_sg_name" {
  description = "The name of the rds sg"
  type        = string
  default     = "RDS_SG"
}

variable "mysql_port" {
  description = "mysql connection port"
  type        = number
  default     = 3306
}

variable "http_port" {
  description = "port 80 for http connection"
  type        = number
  default     = 80
}

variable "tcp_proctocol" {
  description = "tcp protocol"
  type        = string
  default     = "tcp"
}

variable "http_protocol" {
  description = "http protocol"
  type        = string
  default     = "http"
}

variable "all_cidr_block" {
  description = "all cidr block"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

### RDS

variable "rds_engine" {
  description = "using the mysql engine"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "mysql enging version"
  type        = string
  default     = "8.0"
}

variable "rds_engine_sub_version" {
  description = "mysql minor engine version"
  type        = string
  default     = ".40"
}

variable "rds_instance" {
  description = "instance of the database"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_storage_size" {
  description = "database allocated storage"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "ssd storage for the ALL instances"
  type        = string
  default     = "gp3"
}

### ALB

variable "alb_name" {
  description = "alb name"
  type        = string
  default     = "TF-ALB"
}

variable "load_balancer_type" {
  description = "application load balancer"
  type        = string
  default     = "application"
}

variable "alb_cidr" {
  description = "load balancer ipv4 cidr block"
  type        = string
  default     = "0.0.0.0/0"
}

### Auto Scaling Group

variable "asg_name" {
  description = "auto scaling group name"
  type        = string
  default     = "TF-ASG"
}

variable "alb_tg_name" {
  description = "load balancer target group name"
  type        = string
  default     = "ecs_tg"
}

variable "asg_max_size" {
  description = "max amount of EC2s "
  type        = number
  default     = 4
}

variable "asg_min_size" {
  description = "min amount of EC2s"
  type        = number
  default     = 2
}

variable "asg_desired_size" {
  description = "desired amount of EC2s"
  type        = number
  default     = 2
}

variable "launch_template_name" {
  description = "name of the asg launch template"
  type        = string
  default     = "ecs-app-asg"
}

variable "image_id" {
  description = "The id of the machine image (AMI) to use for the server."
  type        = string
  default     = "ami-0509eb4a380d8a316"
  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "instance_type" {
  description = "value"
  type        = string
  default     = "c5.large"
}

variable "instance_storage" {
  description = "amount of storage allocated to the instace"
  type        = number
  default     = 30
}

### ECS

variable "cluster_name" {
  description = "name of the ECS cluster"
  type        = string
  default     = "tf-ecs-ec2"
}

variable "ecs_service_name" {
  description = "name of the ECS service"
  type        = string
  default     = "app-svc"
}

variable "max_scale_step_size" {
  description = "max scaling step size"
  type        = number
  default     = 1
}

variable "min_scale_step_size" {
  description = "min scaling step size"
  type        = number
  default     = 1
}

variable "managed_scaling_status" {
  description = "on or off managed scaling"
  type        = string
  default     = "ENABLED"
}

variable "target_capacity" {
  description = "target capacity desired"
  type        = number
  default     = 100
}

variable "task_name" {
  description = "name of the ECS task"
  type        = string
  default     = "python-task"
}

variable "launch_type" {
  description = "EC2 machine for the type"
  type        = string
  default     = "EC2"
}

variable "task_cpu_allocation" {
  description = "how much cpu to allow the task to use"
  type        = number
  default     = 256
}

variable "task_memory_allocation" {
  description = "how much ram memory to allow the task to use"
  type        = number
  default     = 512
}

variable "task_image" {
  description = "python app as the base image for the tasks"
  type        = string
  default     = "930354804502.dkr.ecr.us-west-1.amazonaws.com/yoram/python-app:latest"
}

variable "desired_count" {
  description = "amount of desired tasks the service runs"
  type        = number
  default     = 6
}

variable "autoscaling_max_capacity" {
  description = "max amount of running tasks in the service"
  type        = number
  default     = 10
}

variable "autoscaling_min_capacity" {
  description = "min amount of running tasks in the service"
  type        = number
  default     = 6
}

variable "autoscaling_service_cpu_target" {
  description = "the cou target value to add more services"
  type        = number
  default     = 60
}

variable "scale_in_out_timeout" {
  description = "how long to wait before to scale in or down services"
  type        = number
  default     = 300
}