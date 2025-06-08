module "waf_alb" {
  source = "dasmeta/modules/aws//modules/waf/"
  name   = "${var.project}-waf_alb-${var.environment}"
  alarms = {
    enabled       = false
    alarm_actions = []
    ok_actions    = []
    sns_topic     = ""
  }

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet"
      priority = 1

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet"
      priority = 2

      override_action = "count"

      visibility_config = {
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesSQLiRuleSet"
      priority = 3

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesSQLiRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesAnonymousIpList"
      priority = 4

      override_action = "count"

      visibility_config = {
        metric_name = "AWSManagedRulesAnonymousIpList-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
  ]

  create_alb_association = true
  alb_arn_list           = [module.alb.arn]

  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project}-waf_metric-${var.environment}"
    sampled_requests_enabled   = true
  }

}