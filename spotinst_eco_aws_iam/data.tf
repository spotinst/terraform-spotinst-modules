data "aws_iam_policy_document" "spotinst_eco_policy_read" {
  statement {
    sid = "ReadAccess"

    actions = [
      "cloudformation:DescribeStacks",
      "cloudformation:GetStackPolicy",
      "cloudformation:GetTemplate",
      "cloudformation:ListStackResources",
      "dynamodb:List*",
      "dynamodb:Describe*",
      "ec2:Describe*",
      "ec2:List*",
      "ec2:GetHostReservationPurchasePreview",
      "ec2:GetReservedInstancesExchangeQuote",
      "elasticache:List*",
      "elasticache:Describe*",
      "cur:*",
      "ce:*",
      "rds:Describe*",
      "rds:ListTagsForResource",
      "redshift:Describe*",
      "trustedadvisor:*",
      "s3:List*",
      "s3:GetBucketLocation",
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "support:*",
      "organizations:List*",
      "organizations:Describe*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid = "S3SyncPermissions"

    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:PutObjectTagging",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::sc-customer-*"
    ]
  }

  statement {
    sid = "S3Billing"

    actions = [
                "s3:get*"
    ]

    resources = [
      "arn:aws:s3:::${var.cost_usage_bucket}/*"
    ]

  }

}
