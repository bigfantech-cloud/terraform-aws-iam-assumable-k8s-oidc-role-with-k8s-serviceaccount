data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_partition  = data.aws_partition.current.partition
  iam_role_name  = var.iam_role_name != null ? var.iam_role_name : "${var.namespace}-${var.service_account_name}-K8sServiceAccountRole"
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    sid     = "GrantK8sSAAccessToAWS"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    effect = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name}"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_oidc_issuer_url, "https://", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }

  dynamic "statement" {
    # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
    for_each = var.allow_self_assume_role ? ["true"] : []

    content {
      sid     = "ExplicitSelfRoleAssumption"
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "AWS"
        identifiers = ["*"]
      }

      condition {
        test     = "ArnLike"
        variable = "aws:PrincipalArn"
        values   = ["arn:${local.aws_partition}:iam::${local.aws_account_id}:role/${local.iam_role_name}"]
      }
    }
  }
}

resource "aws_iam_role" "role" {
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

data "aws_iam_policy_document" "policy_jsons_list" {
  count                   = var.policy_jsons_list != [] ? 1 : 0
  source_policy_documents = var.policy_jsons_list
}

resource "aws_iam_policy" "policy_jsons_list" {
  count = var.policy_jsons_list != [] ? 1 : 0

  name   = "${local.iam_role_name}Policy"
  policy = data.aws_iam_policy_document.policy_document[0].json
}

resource "aws_iam_policy_attachment" "policy_jsons_list" {
  name       = "${local.iam_role_name}_policy_attach"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy_jsons_list.arn
}

resource "aws_iam_role_policy_attachment" "policy_arns_list" {
  for_each = toset(var.policy_arns_list)

  role       = aws_iam_role.role.name
  policy_arn = each.value
}

#---
# K8S SERVICEACCOUNT
#---

resource "kubernetes_service_account" "service_account" {
  count = var.create_serviceaccount ? 1 : 0

  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    labels    = var.service_account_labels
    annotations = merge(
      var.additional_service_account_annotations,
      {
        "eks.amazonaws.com/role-arn" = aws_iam_role.role.arn
      }
    )
  }
  automount_service_account_token = true
}


