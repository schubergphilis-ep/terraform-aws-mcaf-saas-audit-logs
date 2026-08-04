output "arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.arn
}

output "lambda_iam_policy" {
  description = "The IAM policy document that was created for the Lambda function"
  value       = data.aws_iam_policy_document.lambda_iam_policy.json
}

output "s3_lambda_package_object_checksum_sha256" {
  description = "S3 Lambda package object checksum (sha256)"
  value       = aws_s3_object.lambda_package.checksum_sha256
}

output "s3_lambda_package_object_key" {
  description = "S3 Lambda package object key"
  value       = aws_s3_object.lambda_package.key
}

output "s3_lambda_package_object_version" {
  description = "S3 Lambda package object key"
  value       = aws_s3_object.lambda_package.version_id
}
