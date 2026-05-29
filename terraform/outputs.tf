output "snowflake_integration_role_arn" {
  description = "The ARN of the IAM role for Snowflake to assume"
  value       = aws_iam_role.snowflake_role.arn
}