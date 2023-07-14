# get account details
data "aws_caller_identity" "sts_identity" {}
data "aws_region" "current" {}

# cloudwatch log group
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "vpc-flow-logs"
  kms_key_id        = aws_kms_key.flowlogs_key.arn
  retention_in_days = 14
}

# key for cloudwatch log group
resource "aws_kms_key" "flowlogs_key" {
  description         = "encryption key for cloudwatch logs"
  enable_key_rotation = true
  policy              = jsonencode(data.aws_iam_policy_document.keypolicy_cwlogs.json)
}

# key policy
data "aws_iam_policy_document" "keypolicy_cwlogs" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.sts_identity.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Enable cloudwatch logs"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["arn:aws:logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]

    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:log-group:vpc-flow-logs"]
    }
  }
}

# iam role for vpc flowlogs
resource "aws_iam_role" "flowlogs_role" {
  name = "flowlogs_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "flowlogs"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })
}

# IAM policy for flowlogs role
resource "aws_iam_policy" "vpcflowlogs_policy" {
  name        = "vpc-flowlogs-policy"
  description = "IAM policy for vpc flowlogs"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      },
    ]
  })
}

# IAM policy attachment
resource "aws_iam_role_policy_attachment" "policyattach_flowlogs" {
  role       = aws_iam_role.flowlogs_role.arn
  policy_arn = aws_iam_policy.vpcflowlogs_policy.arn
}

# vpc flowlogs
resource "aws_flow_log" "vpc_flow_logs" {
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  iam_role_arn         = aws_iam_role.flowlogs_role.arn
}
