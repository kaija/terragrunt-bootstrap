variable "aws_region" {
  description = "The AWS region to deploy to (e.g. us-west-2)"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type        = string
}

variable "aws_account_stage" {
  description = "The AWS account stage"
  type        = string
}

variable "project_name" {
  description = "The project name"
  type        = string
  default     = "cloud-platform"
}

variable "project_alt" {
  description = "The project alternative name. short name for short naming."
  type        = string
}

