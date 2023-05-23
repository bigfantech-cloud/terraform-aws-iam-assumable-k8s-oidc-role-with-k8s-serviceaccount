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

| Name                      | Description                                                                | Type | Default     |
| ------------------------- | ---------------------------------------------------------------------------- | -- | --|
| `namespace`               | Kubernetes namespace to create ServiceAccount in                            | string |  |
| `cluster_oidc_issuer_url` | EKS cluster OIDC issuer URL                                                 | string |  |
| `oidc_provider_arn`       | EKS cluster OIDC provider ARN                                                | string | |
| `policy_jsons_list`       | List of policies JSON. `policy_jsons_list` or `policy_arns_list` is required | list(string) | |
| `policy_arns_list`        | List of policies ARNS. `policy_arns_list` or `policy_jsons_list` is required | list(string) | |

### Optional Variables

| Name                                                                                               | Description                                                            | Type | Default    |
| -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------- | -- | --- |
| `iam_role_name`                                                                                    | A custom IAM role name. A preset name will be used if not specified | string | null |
| `allow_self_assume_role`                                                                           | Whether to allow Role to self assume the role<br>Ref: https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/ | bool |   false             |
| `create_service_account`                                                                            | Whether to create Kubernetes ServiceAccount or not | bool |   true                    |
| `service_account_name`    | Kubernetes ServiceAccount name                                               | string | null|
| `service_account_labels`                                                                           | ServiceAccount labels map                   | map(any) |         {}                        |
| `additional_service_account_annotations`                                                           | Additional ServiceAccount annotations                     | map(any) |         {}                  |

### Example config

> Check the `example` folder in this repo

### Outputs

| Name            | Description       |
| --------------- | ----------------- |
| `iam_role_arn`  | AWS IAM role ARN  |
| `iam_role_name` | AWS IAM role name |
