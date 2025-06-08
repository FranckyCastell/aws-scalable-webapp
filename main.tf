
module "waf_alb" {
  source = "dasmeta/modules/aws//modules/waf/"
  name   = "test"
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
  alb_arn_list           = ["arn:aws:elasticloadbalancing:us-east-1:*:loadbalancer/"] # Replace with your actual ALB ARN

  visibility_config = {
    metric_name = "test-waf"
  }
}
