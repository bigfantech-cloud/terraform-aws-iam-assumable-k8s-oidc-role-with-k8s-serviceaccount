output "iam_role_arn" {
  description = "AWS IAM role ARN"
  value       = aws_iam_role.role.arn
}

output "iam_role_name" {
  description = "AWS IAM role name"
  value       = aws_iam_role.role.name
}

output "k8s_service_account_name" {
  description = "Name of the Kuberentes ServiceAccount created"
  value       = var.service_account_name
}
