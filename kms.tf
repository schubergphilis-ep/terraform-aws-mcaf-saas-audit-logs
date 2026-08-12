data "aws_iam_policy_document" "kms_key_policy" {
  count = var.kms_key_arn == null ? 1 : 0

  statement {
    sid = "AllowCloudWatchLogsForSaasAuditLogs"
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey*",
    ]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["logs.${local.region}.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"

      values = [
        "arn:aws:logs:${local.region}:${data.aws_caller_identity.current.account_id}:*"
      ]
    }
  }

  statement {
    sid = "AllowSaasAuditLogsViaS3AndSqs"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
    ]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"

      values = [
        "s3.${local.region}.amazonaws.com",
        "sqs.${local.region}.amazonaws.com",
      ]
    }
  }

  statement {
    sid = "AllowSaasAuditLogsViaLambda"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
    ]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"

      values = ["lambda.${local.region}.amazonaws.com"]
    }
  }

  statement {
    sid = "AllowSaasAuditLogsViaSecretStores"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    effect    = "Allow"
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"

      values = [
        "secretsmanager.${local.region}.amazonaws.com",
      ]
    }
  }
}

module "kms_key" {
  count = var.kms_key_arn == null ? 1 : 0

  source  = "schubergphilis-ep/mcaf-kms/aws"
  version = "~> 3.0.0"

  region      = var.region
  name        = var.kms_key_configuration.name
  description = "KMS key used for encrypting all saas audit logs resources"

  default_policy = {
    iam_arns_administrator  = var.kms_key_configuration.iam_arns_administrator
    source_policy_documents = [data.aws_iam_policy_document.kms_key_policy[0].json]
  }
}
