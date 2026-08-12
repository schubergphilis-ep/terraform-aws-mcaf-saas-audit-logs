provider "aws" {
  region = "eu-west-1"
}

module "saas_audit_logs" {
  source = "../.."

  kms_key_configuration = {
    iam_arns_administrator = ["arn:aws:iam::123456789012:role/key-admin"]
  }

  sources = {
    gitlab = {
      api_token = var.gitlab_api_token
    }

    okta = {
      api_token = var.okta_api_token
      api_url   = "https://yourorg.okta.com"
    }

    terraform-cloud = {
      api_token = var.terraform_api_token
    }
  }
}
