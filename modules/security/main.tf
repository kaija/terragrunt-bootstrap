terraform {
  required_providers {
    aws = {
      version = "3.70.0"
    }
  }
}
# ========================
# IAM
# ========================

resource "aws_accessanalyzer_analyzer" "analyzer" {
  analyzer_name = "${var.project_name}-${var.aws_account_stage}-analyzer"
}

# ========================
# S3 bucket related
# ========================

resource "aws_s3_account_public_access_block" "block" {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ========================
# AWS Config
# ========================

resource "aws_config_configuration_aggregator" "account" {
  name = "${var.project_name}-${var.aws_account_stage}-awsconfig"

  account_aggregation_source {
    account_ids = [var.aws_account_id]
    all_regions = true
  }
}

#tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "config" {
  bucket        = "${var.project_name}-${var.aws_account_stage}-awsconfig-bucket"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket                  = aws_s3_bucket.config.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_iam_role" "config" {
  name               = "${var.project_name}-${var.aws_account_stage}-awsconfig"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "config" {
  name   = "${var.project_name}-${var.aws_account_stage}-awsconfig"
  role   = aws_iam_role.config.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.config.arn}",
        "${aws_s3_bucket.config.arn}/*"
      ]
    }
  ]
}
POLICY
}

# ========================
# EBS related
# ========================

resource "aws_ebs_encryption_by_default" "encrypt" {
  enabled = true
}
