locals {
  tags = {
    Environment = var.environment
    Region      = var.aws_region
  }
}

data "aws_caller_identity" "current" {}

module "eks_bottlerocket" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.environment}-control-plane"
  cluster_version = "1.31"
  cluster_endpoint_public_access = true

  # Add access entry for GHA bot
  access_entries = {
    github_actions = {
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/gha-control-plane"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }

    ryan = {
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/ryan"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }

  # EKS Addons
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    aws-ebs-csi-driver     = {}
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    bottlerocket = {
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = var.instance_types

      min_size = var.min_size
      max_size = var.max_size
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = var.desired_size

      # This is not required - demonstrates how to pass additional configuration
      # Ref https://bottlerocket.dev/en/os/1.19.x/api/settings/
      bootstrap_extra_args = <<-EOT
        # The admin host container provides SSH access and runs with "superpowers".
        # It is disabled by default, but can be disabled explicitly.
        [settings.host-containers.admin]
        enabled = false

        # The control host container provides out-of-band access via SSM.
        # It is enabled by default, and can be disabled if you do not expect to use SSM.
        # This could leave you with no way to access the API and change settings on an existing node!
        [settings.host-containers.control]
        enabled = true

        # extra args added
        [settings.kernel]
        lockdown = "integrity"
      EOT
    }
  }

  tags = local.tags
}

## Helm provider
data "aws_eks_cluster" "cluster" {
  name = module.eks_bottlerocket.cluster_name
  depends_on = [ module.eks_bottlerocket ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks_bottlerocket.cluster_name
  depends_on = [ module.eks_bottlerocket ]
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# VPC CNI IRSA
module "vpc_cni_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "vpc-cni"

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn = module.eks_bottlerocket.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}

# EBS CSI IRSA
module "ebs_csi_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "ebs-csi"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks_bottlerocket.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

# AWS Load Balancer Controller
module "aws_load_balancer_controller_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.environment}-control-plane-aws-load-balancer-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks_bottlerocket.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}
# CREATE SERVICE ACCOUNT
# SET SERVICE ACCOUNT CREATE FALSE

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.11.0"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = module.eks_bottlerocket.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = module.aws_load_balancer_controller_irsa_role.iam_role_name
  }

}

# Datadog

## External DNS
module "external_dns_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.environment}-control-plane-external-dns"

  attach_external_dns_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks_bottlerocket.oidc_provider_arn
      namespace_service_accounts = ["external-dns:external-dns"]
    }
  }
}

resource "kubernetes_service_account" "external_dns" {
  metadata {
    name = "external-dns"
    namespace = "external-dns"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.external_dns_irsa_role.iam_role_arn
    }
  }
}

# Helm chart for external-dns
resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns"
  version    = "1.15.0"

  namespace = "external-dns"
  create_namespace = true

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_dns.metadata[0].name
  }

  set {
    name  = "provider"
    value = "aws"
  }
}

# # External Secrets
module "external_secrets_irsa_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "${var.environment}-control-plane-external-secrets"

  attach_external_secrets_policy = true

  oidc_providers = {
    main = {
      provider_arn = module.eks_bottlerocket.oidc_provider_arn
      namespace_service_accounts = ["external-secrets:external-secrets"]
    }
  }
}

resource "kubernetes_service_account" "external_secrets" {
  metadata {
    name = "external-secrets"
    namespace = "external-secrets"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.external_secrets_irsa_role.iam_role_arn
    }
  }
}

resource "helm_release" "external_secrets" {
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "v0.12.1"

  namespace = "external-secrets"
  create_namespace = true

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.external_secrets.metadata[0].name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }
}

resource "kubernetes_manifest" "cluster_secret_store" {

  manifest = {
    "apiVersion" = "external-secrets.io/v1beta1"
    "kind"       = "ClusterSecretStore"
    "metadata" = {
      "name" = "${var.environment}-control-plane-cluster-secret-store"
    }
    "spec" = {
      "provider" = {
        "aws" = {
          "service" = "SecretsManager"
          "region"  = var.aws_region
          "auth" = {
            "jwt" = {
              "serviceAccountRef" = {
                "name"      = kubernetes_service_account.external_secrets.metadata[0].name
                "namespace" = kubernetes_service_account.external_secrets.metadata[0].namespace
              }
            }
          }
        }
      }
    }
  }
}


