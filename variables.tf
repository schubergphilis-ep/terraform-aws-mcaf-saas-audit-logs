variable "bucket_base_name" {
  type        = string
  default     = "saas-audit-logs"
  description = "The base name for the S3 buckets"
}

variable "compress_audit_logs" {
  type        = bool
  default     = true
  description = "Whether to compress the audit logs before uploading to S3"
}

variable "create_bucket" {
  type        = bool
  default     = true
  description = "Whether to create the S3 bucket(s)"
}

variable "create_bucket_per_source" {
  type        = bool
  default     = false
  description = "Whether to create separate buckets per source"
}

variable "created_bucket_names" {
  type = object({
    audit_logs     = string
    lambda_package = string
  })
  default     = null
  description = "Names of existing S3 buckets to use"
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key used to encrypt the resources"
  default     = null
}

variable "kms_key_configuration" {
  type = object({
    iam_arns_administrator = list(string)
    name                   = optional(string, "saas-audit-logs")
  })
  default     = null
  description = "Access configuration for the KMS key created by this module. Only applicable when 'kms_key_arn' is null. 'iam_arns_administrator' grants permissions to manage the key (no cryptographic use). 'name' sets the alias/name of the created key."

  validation {
    condition     = var.kms_key_arn == null || var.kms_key_configuration == null
    error_message = "'kms_key_arn' and 'kms_key_configuration' are mutually exclusive; provide 'kms_key_arn' to use an existing key, or 'kms_key_configuration' to have the module create one, but not both."
  }

  validation {
    condition     = var.kms_key_arn != null || try(length(var.kms_key_configuration.iam_arns_administrator) > 0, false)
    error_message = "When 'kms_key_arn' is not provided, 'kms_key_configuration.iam_arns_administrator' must contain at least one IAM ARN to administer the KMS key created by this module."
  }
}

variable "lambda_log_retention" {
  type        = number
  default     = 365
  description = "The number of days to retain the logs for the Lambda function"
}

variable "region" {
  type        = string
  default     = null
  description = "The AWS region where resources will be created; if omitted the default provider region is used"
}

variable "object_locking" {
  type = object({
    mode  = optional(string, "GOVERNANCE")
    years = optional(number, 1)
  })
  default = {
    mode  = "GOVERNANCE"
    years = 1
  }
  description = "Object locking configuration for S3 log and access-log buckets"
}

variable "python_version" {
  type        = string
  default     = "3.13"
  description = "The version of Python to use for the Lambda function"

  validation {
    condition     = contains(["3.12", "3.13"], var.python_version)
    error_message = "Python version should be 3.12 or 3.13"
  }
}

variable "schedule_expression_timezone" {
  type        = string
  default     = "UTC"
  description = "The timezone in which the scheduling expression is evaluated"
}

variable "scheduled_time" {
  type        = string
  default     = "09:00"
  description = "Time of day to trigger the audit Lambda functions (runs once a day)"
}

variable "sources" {
  type = map(object({
    api_token           = string
    api_url             = optional(string)
    bucket_prefix       = optional(string)
    compress_audit_logs = optional(bool)
    lambda_name         = optional(string)
    lambda_memory_size  = optional(number)
    lambda_log_level    = optional(string, "info")
    secret_name         = optional(string)
    tags                = optional(map(string))
  }))
  description = "Map of sources to fetch audit logs from"

  validation {
    condition     = length(keys(var.sources)) > 0
    error_message = "At least one source must be provided."
  }

  validation {
    condition     = alltrue([for source in keys(var.sources) : contains(["gitlab", "okta", "terraform-cloud"], source)])
    error_message = "Invalid key, supported sources: \"${join("\", \"", ["gitlab", "okta", "terraform-cloud"])}\"."
  }

  validation {
    condition     = alltrue([for source, config in var.sources : !(source == "okta" && config.api_url == null)])
    error_message = "When \"okta\" is specified as a source, the \"api_url\" value must be set."
  }
}

variable "security_group_egress_rules" {
  type = list(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = string
    from_port                    = optional(number, 0)
    ip_protocol                  = optional(string, "-1")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    to_port                      = optional(number, 0)
  }))
  default = [
    {
      description = "Default Security Group rule for SaaS Audit Lambda"
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      to_port     = 443
    }
  ]
}

variable "subnet_ids" {
  type        = list(string)
  default     = null
  description = "List of subnet IDs associated with the Lambda function"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to created resources"
}
