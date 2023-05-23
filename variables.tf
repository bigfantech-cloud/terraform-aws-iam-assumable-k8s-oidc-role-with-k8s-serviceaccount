variable "namespace" {
  description = "Kubernetes namespace to create ServiceAccount in"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "EKS cluster OIDC issuer URL"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS cluster OIDC provider ARN"
  type        = string
}

variable "iam_role_name" {
  description = "IAM role name. A preset name will be used if not specified. Default = null"
  type        = string
  default     = null
}

variable "policy_jsons_list" {
  description = "List of policies JSON"
  type        = list(string)
  default     = []
}

variable "policy_arns_list" {
  description = "List of policies ARNS"
  type        = list(string)
  default     = []
}

variable "allow_self_assume_role" {
  description = <<-EOF
  Whether to allow Role to self assume the role. Default = false.
  Ref: https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  EOF
  type        = bool
  default     = false
}

variable "create_service_account" {
  description = "Whether to create Kubernetes ServiceAccount or not. Default = true"
  type        = bool
  default     = true
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name"
  type        = string
  default     = null
}

variable "service_account_labels" {
  description = "ServiceAccount labels map"
  type        = map(any)
  default     = {}
}

variable "additional_service_account_annotations" {
  description = "Additional ServiceAccount annotations"
  type        = map(any)
  default     = {}
}
