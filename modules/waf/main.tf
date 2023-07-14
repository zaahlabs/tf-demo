# web acl
resource "aws_wafv2_web_acl" "challenge_webacl" {
  name  = "challenge_webacl"
  scope = "CLOUDFRONT"

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "challenge_webacl"
    sampled_requests_enabled   = true
  }

  default_action {
    block {}
  }

  rule {
    name     = "AWSManaged-CoreRuleSet"
    priority = 10

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManaged-CoreRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "waf-ratelimit"
    priority = 20

    statement {
      rate_based_statement {
        limit = 500
      }
    }
    action {
      block {}
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "waf-ratelimit"
      sampled_requests_enabled   = true
    }
  }
}

# associate the webacl
resource "aws_wafv2_web_acl_association" "waf_cloudfront" {
  resource_arn = var.cloudfront_distribution
  web_acl_arn  = aws_wafv2_web_acl.challenge_webacl.arn
}


