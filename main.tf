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
}

resource "aws_iam_policy" "policy" {
  name   = "${var.namespace}_${var.service_account_name}_K8sServiceAccountPolicy"
  policy = data.aws_iam_policy_document.policy_document.json

  tags = module.this.tags
}

data "aws_iam_policy_document" "policy_document" {
  source_policy_documents = var.policies
}

resource "aws_iam_role" "role" {
  name               = "${var.namespace}_${var.service_account_name}_K8sServiceAccountRole"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

resource "aws_iam_policy_attachment" "policy_attach" {
  name       = "${var.namespace}_${var.service_account_name}_policy_attach"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "kubernetes_service_account" "service_account" {
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


