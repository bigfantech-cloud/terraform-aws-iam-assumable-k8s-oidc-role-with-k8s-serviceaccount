data "aws_iam_policy_document" "microservices_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["*"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name = "thecluster"
  # ....
  # ...... other attributes
  # .......

}

resource "kubernetes_namespace" "microservices" {
  metadata {
    name = "microservices"
  }

  depends_on = [
    module.eks
  ]
}

module "microservices_iam_service_account" {
  source  = "bigfantech-cloud/iam-assumable-k8s-oidc-role-with-k8s-serviceaccount/aws"
  version = "1.0.0"

  namespace               = kubernetes_namespace.microservices.metadata.0.name
  service_account_name    = "microservices"
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  oidc_provider_arn       = module.eks.oidc_provider_arn
  policies                = [data.aws_iam_policy_document.microservices_policy.json]
}
