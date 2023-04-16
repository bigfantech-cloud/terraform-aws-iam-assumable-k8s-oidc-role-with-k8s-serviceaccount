variable "namespace" {
  description = "Kubernetes namespace to create ServiceAccount in"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes ServiceAccount name"
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

variable "policies" {
  description = "IAM policy ARN to attach to Kubernetes ServiceAccount federated IAM role"
  type        = list(string)
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
