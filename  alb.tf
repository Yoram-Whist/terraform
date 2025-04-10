module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name               = var.alb_name
  load_balancer_type = var.load_balancer_type

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  # Security Group
  security_group_name = var.alb_sg_name
  security_group_tags = local.common_tags
  security_group_ingress_rules = {
    all_http = {
      from_port   = var.http_port
      to_port     = var.http_port
      ip_protocol = var.tcp_protocol
      cidr_ipv4   = var.alb_cidr
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    ex_http = {
      port     = var.http_port
      protocol = upper(var.http_protocol)

      forward = {
        target_group_key = var.alb_tg_name
      }
    }
  }

  target_groups = {
    "${var.alb_tg_name}" = {
      backend_protocol                  = var.http_protocol
      backend_port                      = var.tcp_protocol
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = upper(var.http_protocol)
        timeout             = 5
        unhealthy_threshold = 2
      }

      # Theres nothing to attach here in this definition. Instead,
      # ECS will attach the IPs of the tasks to this target group
      create_attachment = false
    }
  }

  tags = local.common_tags
}