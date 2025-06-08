module "asg" {

  source                    = "terraform-aws-modules/autoscaling/aws"
  iam_instance_profile_name = aws_iam_instance_profile.ec2_cloudwatch_profile.name

  name = var.asg_name

  min_size                  = 0
  max_size                  = 3
  desired_capacity          = 2
  health_check_type         = "ELB"
  vpc_zone_identifier       = module.vpc.public_subnets
  health_check_grace_period = 300

  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      checkpoint_delay       = 600
      checkpoint_percentages = [35, 70, 100]
      instance_warmup        = 300
      min_healthy_percentage = 50
      max_healthy_percentage = 100
    }
    triggers = var.asg_triggers
  }

  launch_template_name   = "${var.project}-template-${var.environment}"
  update_default_version = true

  image_id          = var.ami_id
  instance_type     = var.ec2_instance_type
  ebs_optimized     = true
  enable_monitoring = true
  user_data = base64encode(templatefile("${path.module}/templates/userdata.tpl", {
  }))


  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.security_group_asg.security_group_id]
    }
  ]

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { WhatAmI = "Volume" }
    }
  ]

  tags = var.tags
}