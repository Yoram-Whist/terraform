module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.2.0"
  # Autoscaling group
  name = var.asg_name

  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_size
  wait_for_capacity_timeout = 0
  health_check_type         = var.instance_type
  vpc_zone_identifier       = module.vpc.private_subnets

  # Launch template
  launch_template_name        = "ecs-app-asg"
  launch_template_description = "TF Launch template"
  update_default_version      = true

  image_id          = var.image_id
  instance_type     = "c5.large"
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
      security_groups           = [aws_security_group.ecs_sg.id]
      sociate_public_ip_address = false # Disable auto-assign public IP
    }
  ]

  # ECS Cluster association
  user_data = base64encode(templatefile("${path.module}/templates/ec2_asg_sh.tpl", {
    ecs_cluster_name = module.ecs_cluster.name # ecs.cluster_name
  }))

  iam_instance_profile_name = "ecsInstanceRole"

  tags = {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

}
