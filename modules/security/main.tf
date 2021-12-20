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
