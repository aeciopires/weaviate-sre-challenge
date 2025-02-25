#----------------------
# ATTENTION!!! Some content and value I getting from my other git public repository that contains good practices to create EKS cluster and other AWS resources
# Reference: https://github.com/aeciopires/adsoft
#----------------------

# SUGGESTION-0 => The original code have not a variables.tf file to customize the values according different environments.
# I created the variables.tf and output.tf files, to respectively pass arguments and see results

# SUGGESTION-1 => The original code not follow the style code like identation recomended by official documentation
# I used terraform fmt to fix this. Reference: https://developer.hashicorp.com/terraform/cli/commands/fmt

################################################################################
# Backend
################################################################################

# SUGGESTION-2 => The original code does not have config to store tfstate in AWS-S3 bucket.
# Is a good pratice store tfstate in a remote bucket shared with the team to avoid concurrency problems, facilitate the collaboration, 
# allow cross-team and cross-project consistency, facilitate disaster recovery and replication
# Reference: https://developer.hashicorp.com/terraform/language/backend/s3
terraform {
  backend "s3" {
    # The AWS-S3 bucket and DynamoDB must to be created previosly
    bucket         = "terraform-remote-state-gyr4"
    dynamodb_table = "terraform-state-lock-dynamo-gyr4"
    key            = "customer-gyr4/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    profile        = "myaccount"
  }

  # SUGGESTION-3 => The original code does not a required providers block.
  required_version = "~> 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, <6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }
}

################################################################################
# Providers
################################################################################

provider "aws" {
  # SUGGESTION-4 => The original code does not have the profile argument in this block
  profile = var.aws_profile
  region  = var.region

  # SUGGESTION-5 => The default_tags block may not be supported depending on the version of the AWS provider you are using.
  # But in this case I use a new version
  default_tags {
    tags = local.aws_default_tags
  }
}

# This is correct according documentation: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#exec-plugins
provider "kubernetes" {
  host                   = data.aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
  }
}


# SUGGESTION-6 => The original code uses v1alpha1 API version. But according the documentation: https://registry.terraform.io/providers/hashicorp/helm/latest/docs#exec-plugins
# The "helm" provider needs to upgrade to use v1beta1 API.
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.main.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
    }
  }
}

# SUGGESTION-7 => This code is correct according this doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster.html
# But this data statement is required for addon configuration with kubernetes and helm providers where EKS cluster does not exist yet to avoid race condition.
# Known error see more in the WARNING block: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#stacking-with-managed-kubernetes-cluster-resources
# The replace is used just to get the cluster name from an output that's only known after the cluster creation (module.weaviate_eks.cluster_name is known before the apply), which sets an implicit dependency.
data "aws_eks_cluster" "main" {
  //name = var.eks_cluster_name
  name = replace(module.weaviate_eks.cluster_arn, "/arn.*cluster//", "")
}


################################################################################
# Local Variables
################################################################################


locals {
  aws_default_tags = merge(
    { "clusterName" : var.eks_cluster_name },
    var.aws_default_tags,
  )
  customer_identifier         = trimprefix(var.eks_cluster_name, "wv-")
  customer_cluster_identifier = "prod-dedicated-enterprise"

  vpc_id = "CHANGE_HERE"
  vpc_public_subnet_tags = {
    "type"                                          = "public",
    "kubernetes.io/role/elb"                        = "1",      # For use with ALB of type internet
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared", # For use with node autoscaling
  }

  vpc_private_subnet_tags = {
    "type"                                           = "private",
    "kubernetes.io/role/internal-elb"                = "1",                       # For use with ALB of type internal
    "kubernetes.io/cluster/${var.eks_cluster_name}"  = "shared",                  # For use with node autoscaling
    "karpenter.sh/discovery/${var.eks_cluster_name}" = "${var.eks_cluster_name}", # For use with Karpenter
  }

  # See bellow pages for review access policy permissions
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policy-permissions.html
  # https://docs.aws.amazon.com/eks/latest/userguide/access-entries.html
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html
  # https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest#cluster-access-entry
  # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-eks-accessentry.html
  eks_access_entries = {
    admin1-example = {
      principal_arn = "arn:aws:iam::${var.aws_account_id}:root" # CHANGE_HERE
      policy_associations = {
        admin1-example = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    #admin2-example = {
    #  principal_arn = "arn:aws:iam::${var.aws_account_id}:user/someone" # CHANGE_HERE
    #  policy_associations = {
    #    admin2-example = {
    #      policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
    #      access_scope = {
    #        namespaces = []
    #        type       = "cluster"
    #      }
    #    }
    #  }
    #},
    #dev1-example = {
    #  principal_arn = "arn:aws:iam::${var.aws_account_id}:user/someone2" # CHANGE_HERE
    #  policy_associations = {
    #    dev1-example = {
    #      policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
    #      access_scope = {
    #        namespaces = []
    #        type       = "cluster"
    #      }
    #    }
    #  }
    #},
    #manager1-example = {
    #  principal_arn = "arn:aws:iam::${var.aws_account_id}:role/something" # CHANGE_HERE
    #  policy_associations = {
    #    manager1-example = {
    #      policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
    #      access_scope = {
    #        namespaces = []
    #        type       = "cluster"
    #      }
    #    }
    #  }
    #},
  }

  aws_load_balancer_controller_yaml = <<-EOF
    clusterName: "${var.eks_cluster_name}"
    region: "${var.region}"
    vpcId: "${local.vpc_id}"

    ingressClass: alb
    ingressClassParams:
      create: true
      name: alb

    resources:
      limits:
        memory: 128Mi
      requests:
        cpu: 100m
        memory: 128Mi

    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app.kubernetes.io/name: aws-load-balancer-controller
          namespaces:
          - kube-system
          topologyKey: kubernetes.io/hostname
    enableServiceMutatorWebhook: false
  EOF


  cluster_autoscaler_yaml = <<-EOF
    replicaCount: 2

    image:
      tag: "v1.32.0"

    priorityClassName: "system-cluster-critical"

    autoDiscovery:
      clusterName: "${var.eks_cluster_name}"
      tags:
        - "k8s.io/cluster-autoscaler/enabled"
        - "k8s.io/cluster-autoscaler/${var.eks_cluster_name}"

    cloudProvider: aws

    awsRegion: "${var.region}"

    extraArgs:
      expander: least-waste

    updateStrategy:
      type: RollingUpdate
      rollingUpdate:
        maxUnavailable: 1

    affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchLabels:
              app.kubernetes.io/name: aws-cluster-autoscaler
          namespaces:
          - kube-system
          topologyKey: kubernetes.io/hostname
  EOF
}


################################################################################
# EKS Cluster and VPC Configuration
################################################################################

# SUGGESTION-8 => Used public module to create VPC
module "weaviate_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.0"

  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  azs                    = var.vpc_azs
  public_subnets         = var.vpc_public_subnets
  private_subnets        = var.vpc_private_subnets
  create_igw             = true
  enable_dns_support     = true
  enable_dns_hostnames   = true
  enable_vpn_gateway     = false
  enable_ipv6            = false
  enable_nat_gateway     = true
  single_nat_gateway     = var.vpc_single_nat_gateway
  one_nat_gateway_per_az = var.vpc_one_nat_gateway_per_az
  public_subnet_tags     = local.vpc_public_subnet_tags
  private_subnet_tags    = local.vpc_private_subnet_tags
  vpc_tags               = local.aws_default_tags
  tags                   = local.aws_default_tags

}

# SUGGESTION-9 => Used public module to create EKS 1.32
module "weaviate_eks" {
  depends_on = [
    module.weaviate_vpc,
    module.weaviate_kms,
    module.weaviate_keypair,
  ]

  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  #--------------------------
  # General
  #--------------------------
  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  #--------------------------
  # Network
  #--------------------------
  vpc_id     = module.weaviate_vpc.vpc_id
  subnet_ids = module.weaviate_vpc.private_subnets


  #--------------------------
  # Log
  #--------------------------
  create_cloudwatch_log_group = true
  cloudwatch_log_group_class  = "INFREQUENT_ACCESS"

  # After a cost analysis with cloudwatch it is recommended to keep the authenticator log only
  cluster_enabled_log_types              = var.eks_cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = var.eks_cloudwatch_log_group_retention_in_days


  #--------------------------
  # Security
  #--------------------------
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.eks_cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access      = true

  create_kms_key = false
  cluster_encryption_config = {
    provider_key_arn = module.weaviate_kms.key_arn,
    resources        = ["secrets"]
  }

  create_cluster_security_group           = true
  cluster_security_group_additional_rules = {}
  node_security_group_additional_rules    = {}
  node_security_group_tags                = {}
  cluster_additional_security_group_ids   = []


  #--------------------------
  # Worker node
  #--------------------------
  # More options in page: https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/modules/eks-managed-node-group#inputs
  eks_managed_node_groups = {
    "on-demand" = {
      name          = "${var.eks_cluster_name}-ondemand"
      capacity_type = "ON_DEMAND"
      key_name      = module.weaviate_keypair.key_pair_name
      min_size      = 2
      max_size      = 20
      desired_size  = 2
      # See page https://aws.amazon.com/pt/ec2/instance-types/ to find type, resources and price of instance
      # Other sites: 
      # https://spot.cloudpilot.ai/aws?instance=m5a.large#region=us-east-1
      # https://learnk8s.io/kubernetes-instance-calculator
      # 
      #
      # ec2-instance-selector --memory CHANGE_HERE --vcpus CHANGE_HERE --cpu-architecture x86_64 --hypervisor nitro --service eks --usage-class on-demand --region AWS_REGION --profile AWS_PROFILE
      #
      # Example:
      # ec2-instance-selector --memory 8 --vcpus 2 --cpu-architecture x86_64 --hypervisor nitro --usage-class on-demand --region us-east-2 --profile myaccount
      instance_types = [
        "m5.large",
        "m5a.large",
        "m5ad.large",
        "m5d.large",
        "m5dn.large",
        "m5n.large",
        "m5zn.large",
        "m6a.large",
        "m6i.large",
        "m6id.large",
        "m6idn.large",
        "m6in.large",
        "m7a.large",
        "m7i-flex.large",
        "m7i.large",
        "t3.large",
        "t3a.large",
      ]
      enable_monitoring = false

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size = 50
            volume_type = "gp3"
            encrypted   = true
          }
        }
      }

      network_interfaces = [
        {
          associate_public_ip_address = false
        }
      ]
    }
  }


  #--------------------------
  # EKS components optionals
  #--------------------------
  # More info about EKS Addons:
  # https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-eks.html
  # https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html
  # https://docs.aws.amazon.com/eks/latest/userguide/workloads-add-ons-available-vendors.html
  # https://docs.aws.amazon.com/eks/latest/userguide/community-addons.html
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    aws-ebs-csi-driver     = {}
    metrics-server         = {}
    #aws-efs-csi-driver           = {}
    #aws-mountpoint-s3-csi-driver = {}
  }


  #--------------------------
  # EKS roles, users, accounts and tags
  #--------------------------
  # Adds the current caller identity as an administrator via cluster access entry
  # If true, EKS uses aws-auth configmap for authentication
  # If false,EKS uses access entry for authentication
  enable_cluster_creator_admin_permissions = false
  authentication_mode                      = "API"
  access_entries                           = local.eks_access_entries
  tags                                     = local.aws_default_tags
}


################################################################################
# High Availability Setup for Weaviate
################################################################################

# SUGGESTION-10 => Where is the ./modules/weaviate code? Whithout this code, I can not create the infrastructure correctly.
module "weaviate_helm" {

  # SUGGESTION-11 => Is good pratice put depends_on block in begin of resource configuration to indentify easier the dependencies.
  # This depends_on may be unnecessary because Terraform manages dependencies implicitly.
  # But in this case, I keep this block for a configuration more explicited.
  depends_on = [
    kubernetes_namespace.weaviate-namespace
  ]

  source = "./modules/weaviate"
  # ... (existing configuration)


  # HA Setup
  replica_count = 2


  # Weaviate-specific configurations
  # SUGGESTION-12 => For high availability (HA), 1 replica is not sufficient. In original code, ideally it should be at least equal to 2
  # I changed value to 2
  weaviate_replication_factor = 2


  # Node Affinity and Anti-Affinity (to spread pods across AZs)
  affinity = {
    podAntiAffinity = {
      requiredDuringSchedulingIgnoredDuringExecution = [
        {
          labelSelector = {
            matchExpressions = [
              {
                key      = "app"
                operator = "In"
                values   = ["weaviate"]
              },
            ]
          },
          topologyKey = "topology.kubernetes.io/zone"
        },
      ]
    }
  }

  # Tolerations (if needed based on your taints setup)
  tolerations = [
    # Tolerations configuration here
  ]


  # Persistent Volume Claim Issue
  volume_claim_templates = [{
    metadata = {
      name = "weaviate-data"
    }
    spec = {
      accessModes = ["ReadWriteOnce"]
      resources = {
        requests = {
          storage = "10Gi"
        }
      }
    }
  }]
}

################################################################################
# Additional Modules and Resources
################################################################################

# What additional modules should be added here?

# SUGGESTION-13 => Used public module to manage EKS blueprints
module "weaviate_eks_addon_blueprints" {
  depends_on = [
    module.weaviate_eks,
    module.weaviate_vpc,
  ]

  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "1.19.0"

  # References:
  # https://aws-ia.github.io/terraform-aws-eks-blueprints/
  # https://github.com/aws-ia/terraform-aws-eks-blueprints
  # Without IRSA: https://registry.terraform.io/modules/aws-ia/eks-blueprints-addons/aws/latest
  # With IRSA: https://registry.terraform.io/modules/aws-ia/eks-blueprints-addon/aws/latest
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/amazon-eks-addons.md
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/helm-release.md
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/architectures.md

  cluster_name      = module.weaviate_eks.cluster_name
  cluster_endpoint  = module.weaviate_eks.cluster_endpoint
  cluster_version   = module.weaviate_eks.cluster_version
  oidc_provider_arn = module.weaviate_eks.oidc_provider_arn

  # References:
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/aws-load-balancer-controller.md
  # https://artifacthub.io/packages/helm/aws/aws-load-balancer-controller
  aws_load_balancer_controller = {
    name = "aws-load-balancer-controller"
    # Install version v2.11.0 of aws-load-balancer-controller.
    # See new changes on release notes of application: https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases
    chart_version = "1.11.0"
    repository    = "https://aws.github.io/eks-charts"
    namespace     = "kube-system"
    values = [
      local.aws_load_balancer_controller_yaml
    ]
  }


  # References:
  # https://github.com/aws-ia/terraform-aws-eks-blueprints-addons/blob/main/docs/addons/cluster-autoscaler.md
  # https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
  cluster_autoscaler = {
    name = "cluster-autoscaler"
    # Install version 1.32.0 of cluster-autoscaler chart. 
    # See new changes on release notes of application: https://github.com/kubernetes/autoscaler/releases
    chart_version = "9.46.0"
    repository    = "https://kubernetes.github.io/autoscaler"
    namespace     = "kube-system"
    values = [
      local.cluster_autoscaler_yaml
    ]
  }

  tags = local.aws_default_tags

}

# SUGGESTION-14 => Used public module to create KMS
module "weaviate_kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.1"

  create                  = var.create_kms_key
  description             = var.kms_key_description
  aliases                 = var.kms_key_aliases
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = var.kms_key_deletion_window_in_days
  enable_key_rotation     = var.enable_kms_key_rotation
  is_enabled              = true
  multi_region            = false
  tags                    = local.aws_default_tags
}

# SUGGESTION-15 => Used public module to create EC2 keypair
module "weaviate_keypair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "2.0.3"

  key_name   = var.key_name
  public_key = var.public_key_content
  tags       = local.aws_default_tags
}

################################################################################
# Kubernetes Namespace for Weaviate
################################################################################

# This code is correctly according this documentation: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace
resource "kubernetes_namespace" "weaviate-namespace" {
  metadata {
    name = var.namespace
  }
}
