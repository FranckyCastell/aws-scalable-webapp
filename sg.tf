module "security_group_alb" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.project}-alb-sg-${var.environment}"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTP from anywhere"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow HTTPS from anywhere"
    }
  ]

  egress_rules = ["all-all"]

  tags = var.tags
}


module "security_group_asg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.project}-asg-sg-${var.environment}"
  vpc_id = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "Allow HTTP from ALB"
      source_security_group_id = module.security_group_alb.security_group_id
    },
    {
      from_port                = 8080
      to_port                  = 8090
      protocol                 = "tcp"
      description              = "Allow user-service ports from ALB"
      source_security_group_id = module.security_group_alb.security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = var.tags
}

module "security_group_db" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.project}-db-sg-${var.environment}"
  vpc_id = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "Allow MySQL access from ASG instances"
      source_security_group_id = module.security_group_asg.security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = var.tags
}
