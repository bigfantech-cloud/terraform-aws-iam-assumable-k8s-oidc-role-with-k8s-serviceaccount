output "iam_role_arn" {
  description = "AWS IAM role ARN"
  value       = aws_iam_role.role.arn
}

output "iam_role_name" {
  description = "AWS IAM role name"
  value       = aws_iam_role.role.name
}
