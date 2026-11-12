mock_provider "aws" {
  mock_data "aws_caller_identity" {
    defaults = { account_id = "123456789012" }
  }

  mock_data "aws_iam_policy_document" {
    defaults = { json = "{}" }
  }
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "basic" {
  command = plan

  variables {
    kms_key_arn = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    sources     = {}
  }

  expect_failures = [
    var.sources,
  ]
}

run "access_logging_enabled" {
  command = plan

  variables {
    kms_key_arn = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    sources     = { terraform-cloud = { api_token = "token" } }
  }

  assert {
    condition     = length(module.bucket_for_access_logs) == 1 && length(module.bucket_for_lambda_package_access_logs) == 1
    error_message = "Expected the access logs buckets to be created when s3_access_logging is enabled (default)."
  }

  assert {
    condition = local.access_logs_bucket_names == {
      audit_logs     = "saas-audit-logs-access-logs-123456789012"
      lambda_package = "saas-audit-logs-lambda-access-logs-123456789012"
    }
    error_message = "Expected the access logs buckets to be named '<bucket_base_name>-access-logs-<account-id>' and '<bucket_base_name>-lambda-access-logs-<account-id>'."
  }

  assert {
    condition = local.bucket_lifecycle_rules["access-logs"] == {
      id                                = "access-logs"
      enabled                           = true
      abort_incomplete_multipart_upload = { days_after_initiation = 3 }
      expiration                        = { days = 720 }
      noncurrent_version_expiration     = { noncurrent_days = 7 }
      transition                        = [{ days = 90, storage_class = "GLACIER_IR" }]
    }
    error_message = "Expected the default access logs retention to expire after 720 days, transition to GLACIER_IR after 90 days and delete noncurrent versions after 7 days."
  }
}

run "access_logging_long_bucket_base_name" {
  command = plan

  variables {
    bucket_base_name = "mns-core-audit-saas-audit-logs-storage-prod"
    kms_key_arn      = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    sources          = { terraform-cloud = { api_token = "token" } }
  }

  assert {
    condition     = local.access_logs_bucket_names["audit_logs"] == "mns-core-audit-saas-audit-logs-storage-access-logs-123456789012"
    error_message = "Expected bucket_base_name to be truncated so the access logs bucket name fits the 63 character limit."
  }

  assert {
    condition     = local.access_logs_bucket_names["lambda_package"] == "mns-core-audit-saas-audit-logs-lambda-access-logs-123456789012"
    error_message = "Expected the trailing '-' left by truncating bucket_base_name to be trimmed."
  }
}

run "access_logging_disabled" {
  command = plan

  variables {
    kms_key_arn       = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    s3_access_logging = { enabled = false }
    sources           = { terraform-cloud = { api_token = "token" } }
  }

  assert {
    condition     = length(module.bucket_for_access_logs) == 0 && length(module.bucket_for_lambda_package_access_logs) == 0
    error_message = "Expected no access logs buckets to be created when s3_access_logging is disabled."
  }
}

run "access_logging_retention" {
  command = plan

  variables {
    kms_key_arn = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    sources     = { terraform-cloud = { api_token = "token" } }

    s3_access_logging = {
      expiration_days          = 730
      transition_days          = 180
      transition_storage_class = "GLACIER"
    }
  }

  assert {
    condition     = local.bucket_lifecycle_rules["access-logs"].expiration.days == 730
    error_message = "Expected the access logs expiration to match s3_access_logging.expiration_days."
  }

  assert {
    condition     = local.bucket_lifecycle_rules["access-logs"].transition[0] == { days = 180, storage_class = "GLACIER" }
    error_message = "Expected the access logs transition to match s3_access_logging.transition_days and transition_storage_class."
  }
}

run "access_logging_invalid_retention" {
  command = plan

  variables {
    kms_key_arn       = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    s3_access_logging = { expiration_days = 30 }
    sources           = { terraform-cloud = { api_token = "token" } }
  }

  expect_failures = [
    var.s3_access_logging,
  ]
}

run "audit_lambda_access_logging_enabled" {
  command = plan

  module {
    source = "./modules/audit-lambda"
  }

  variables {
    api_token        = "token"
    api_url          = "https://gitlab.com/api/v4"
    bucket_base_name = "gitlab-audit-logs"
    bucket_prefix    = "gitlab"
    kms_key_arn      = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    lambda_name      = "gitlab-audit-log-fetcher"
    lambda_pkg_path  = "files/pkg/lambda_gitlab_python3.13.zip"
    secret_name      = "/audit-log-tokens/gitlab"
    service_name     = "GitLab"
  }

  assert {
    condition     = length(module.bucket_for_access_logs) == 1 && length(module.bucket_for_lambda_package_access_logs) == 1
    error_message = "Expected the audit-lambda module to create the access logs buckets when s3_access_logging is enabled (default)."
  }

  assert {
    condition = local.access_logs_bucket_prefixes == {
      audit_logs     = "gitlab-audit-logs-access-logs"
      lambda_package = "gitlab-audit-logs-lambda-access-logs"
    }
    error_message = "Expected the audit-lambda module to prefix the access logs buckets with '<bucket_base_name>-access-logs' and '<bucket_base_name>-lambda-access-logs'."
  }
}

run "audit_lambda_access_logging_long_bucket_base_name" {
  command = plan

  module {
    source = "./modules/audit-lambda"
  }

  variables {
    api_token        = "token"
    api_url          = "https://app.terraform.io/api/v2/organization/audit-trail"
    bucket_base_name = "terraform-cloud-audit-logs"
    bucket_prefix    = "terraform-cloud"
    kms_key_arn      = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    lambda_name      = "terraform-cloud-audit-log-fetcher"
    lambda_pkg_path  = "files/pkg/lambda_terraform-cloud_python3.13.zip"
    secret_name      = "/audit-log-tokens/terraform-cloud"
    service_name     = "Terraform Cloud"
  }

  assert {
    condition = local.access_logs_bucket_prefixes == {
      audit_logs     = "terraform-cloud-audit-log-access-logs"
      lambda_package = "terraform-cloud-au-lambda-access-logs"
    }
    error_message = "Expected the audit-lambda module to truncate bucket_base_name so the access logs bucket prefixes fit the 37 character limit."
  }
}

run "audit_lambda_access_logging_long_bucket_base_name_trailing_hyphen" {
  command = plan

  module {
    source = "./modules/audit-lambda"
  }

  variables {
    api_token        = "token"
    api_url          = "https://gitlab.com/api/v4"
    bucket_base_name = "acme-gitlab-audit-logs-store"
    bucket_prefix    = "gitlab"
    kms_key_arn      = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    lambda_name      = "gitlab-audit-log-fetcher"
    lambda_pkg_path  = "files/pkg/lambda_gitlab_python3.13.zip"
    secret_name      = "/audit-log-tokens/gitlab"
    service_name     = "GitLab"
  }

  assert {
    condition     = local.access_logs_bucket_prefixes["lambda_package"] == "acme-gitlab-audit-lambda-access-logs"
    error_message = "Expected the audit-lambda module to trim the trailing '-' left by truncating bucket_base_name."
  }
}

run "audit_lambda_access_logging_disabled" {
  command = plan

  module {
    source = "./modules/audit-lambda"
  }

  variables {
    api_token         = "token"
    api_url           = "https://gitlab.com/api/v4"
    bucket_base_name  = "gitlab-audit-logs"
    bucket_prefix     = "gitlab"
    kms_key_arn       = "arn:aws:kms:eu-central-1:${run.setup.account_id}:key/${run.setup.random_uuid}"
    lambda_name       = "gitlab-audit-log-fetcher"
    lambda_pkg_path   = "files/pkg/lambda_gitlab_python3.13.zip"
    s3_access_logging = { enabled = false }
    secret_name       = "/audit-log-tokens/gitlab"
    service_name      = "GitLab"
  }

  assert {
    condition     = length(module.bucket_for_access_logs) == 0 && length(module.bucket_for_lambda_package_access_logs) == 0
    error_message = "Expected the audit-lambda module to create no access logs buckets when s3_access_logging is disabled."
  }
}
