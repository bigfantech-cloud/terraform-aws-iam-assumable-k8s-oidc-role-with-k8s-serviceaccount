# BigFantech-Cloud

We automate your infrastructure.
You will have full control of your infrastructure, including Infrastructure as Code (IaC).

To hire, email: `bigfantech@yahoo.com`

# Purpose of this code

> Terraform module

- Create AWS IAM role with Kubernetes federated OIDC permission
- Kubernetes ServiceAccount and associate with the IAM role.

## Required Providers

| Name                              | Description |
| --------------------------------- | ----------- |
| aws (hashicorp/aws)               | >= 4.47     |
| kubernetes (hashicorp/kubernetes) | >= 2.10     |

## Variables

### Required Variables

| Name                      | Description                                                                  |
| ------------------------- | ---------------------------------------------------------------------------- |
| `namespace`               | Kubernetes namespace to create ServiceAccount in                             |
| `cluster_oidc_issuer_url` | EKS cluster OIDC issuer URL                                                  |
| `oidc_provider_arn`       | EKS cluster OIDC provider ARN                                                |
| `service_account_name`    | Kubernetes ServiceAccount name                                               |
| `policy_jsons_list`       | List of policies JSON. `policy_jsons_list` or `policy_arns_list` is required |
| `policy_arns_list`        | List of policies ARNS. `policy_arns_list` or `policy_jsons_list` is required |

### Optional Variables

| Name                                                                                               | Description                                                                |
| -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| `iam_role_name`                                                                                    | IAM role name. A preset name will be used if not specified. Default = null |
| `allow_self_assume_role`                                                                           | Whether to allow Role to self assume the role. Default = false             |
| Ref: https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/ |
| `create_serviceaccount`                                                                            | Whether to create ServiceAccount or not. Default = true                    |
| `service_account_labels`                                                                           | ServiceAccount labels map                                                  |
| `additional_service_account_annotations`                                                           | Additional ServiceAccount annotations                                      |

### Example config

> Check the `example` folder in this repo

### Outputs

| Name            | Description       |
| --------------- | ----------------- |
| `iam_role_arn`  | AWS IAM role ARN  |
| `iam_role_name` | AWS IAM role name |
