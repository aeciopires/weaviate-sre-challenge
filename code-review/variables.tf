################################################################################
# General
################################################################################
variable "aws_profile" {
  description = "AWS profile name."
  type        = string
  default     = "myaccount"
}

variable "aws_account_id" {
  description = "AWS Account ID."
  type        = string
  default     = "CHANGE_HERE"
}

variable "region" {
  description = "AWS region. Reference: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions."
  type        = string
  default     = "us-east-2"
}

variable "aws_default_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default = {
    environment = "testing",
    terraform   = "true",
    scost       = "customer-xpto",
  }
}

variable "namespace" {
  description = "Name of the namespace, must be unique. Cannot be updated."
  type        = string
  default     = "weaviate"
}

variable "key_name" {
  description = "The name for the key pair. Conflicts with `key_name_prefix`"
  type        = string
  default     = "key-gyr4"
}

variable "public_key_content" {
  description = "The public key material"
  type        = string
  # For create key pair RSA (without passphrase):
  # ssh-keygen -t rsa -b 4096 -v -f ~/key-gyr4.pem
  # Copy content public key without USER and HOST.
  # cat ~/key-gyr4.pem.pub | cut -d " " -f1,2
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGaj/Af6UpsosJoP7Z3AEW6qf+9qQsIpYhbWR9ZXfo0M5/HorpCe/OqqyMwjLwfZb6TCDKDjH/9MK5Y3VxoL/SF/ECjk3SJM5NQO/NWZojZUYM8nTkkc0sqsF7MNJgN4I0SFeigJwWpYE2h0NAJTadMIt9jY9OAEcH1FIcpcBgE9SuL4SvZm7CDbBlSloMoGqBS+BB/9sHc7UCANFR0FrAFdwMKGYUmlOmMJlklbryoSuht8A5fWGo+iPtkksVgJ07fIlnkDiFhJIiaM4ScEd5g8OwjrmZjfx4+pyQlEAXKiYwR5T/05gHomMCNdUZfLjIAzLRlcaRTxQ6CVhRUlB4KYcoYdpc8sbw8stVh6p0uRUZ9O+cKoEcyQv8gq0pUoq+er3+inHIlcUY+nLNPGFRlRcWzZ0Dd96QeJclEByln7vRVZDokKyn1y41P/jV2FtXdt/z/MbCYxhqtWxXQtDpIuauW6aPU9CDyjPgif3KjluxILYH7lyw8uKJuJM3pV0S15ZVdu6a3GeVrGRYMx4Gq6QyFcc9Rtl3E1QhFFxXWFvpMkIfeiax5HfQHE+XHWKN38LXR+8ZjQbMZSD/8/WJP2K9YVLIsRfLclwwkccYGEvMfiQuDIx7YjLZ+lF8WBGNUswbibDhiDK9aQLZ0n4bvGRrPtWgbE5oJm8AjeQi2w=="
}

################################################################################
# EKS cluster
################################################################################
variable "eks_cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)."
  type        = list(string)
  default     = ["authenticator"]
}

variable "eks_cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "cluster1-gyr4"
  validation {
    condition     = length(var.eks_cluster_name) <= 38
    error_message = "The 'cluster_short_name' value must be lower or equal than 38 characters."
  }
}

variable "eks_cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.25`)."
  type        = string
  default     = "1.32"
}

################################################################################
# CloudWatch Log Group
################################################################################
variable "eks_cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 7 days."
  type        = number
  default     = 7
}

################################################################################
# KMS Key
################################################################################
variable "create_kms_key" {
  description = "Enable creation of AWS-KMS."
  type        = bool
  default     = true
}

variable "kms_key_description" {
  description = "The description of the key as viewed in AWS console"
  type        = string
  default     = "General KMS encryption key"
}

variable "kms_key_deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between `7` and `30`, inclusive. If you do not specify a value, it defaults to `30`"
  type        = number
  default     = 7
}

variable "enable_kms_key_rotation" {
  description = "Specifies whether key rotation is enabled. Defaults to `true`"
  type        = bool
  default     = false
}

variable "kms_key_aliases" {
  description = "A list of aliases to create. Note - due to the use of `toset()`, values must be static strings and not computed values"
  type        = list(string)
  default     = ["alias/customer-xpto-testing"]
}


################################################################################
# VPC
################################################################################

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "net-gyr4"
}

variable "vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  # http://jodies.de/ipcalc?host=172.31.240.0&mask1=20&mask2=22
  default = "172.31.240.0/20"
}

variable "vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
  # https://aws.amazon.com/premiumsupport/knowledge-center/vpc-map-cross-account-availability-zones/
  # AZ-IDs are assigned automatically by AWS when creating an account
  # and to find them you can use the command below.
  #
  # Command:
  # aws ec2 describe-availability-zones --region REGION --profile PROFILE
  #
  # In case of a new account without resources provisioned in the VPC, you can open a ticket in AWS 
  # to change the AZ-ID mapping and have different accounts with the same mapping.
  # In the future this facilitates the use of private-link cross accounts.
  default = [
    "use2-az1",
    "use2-az2"
  ]
}

variable "vpc_public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default = [
    "172.31.240.0/22",
    "172.31.244.0/22"
  ]
}

variable "vpc_private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default = [
    "172.31.248.0/22",
    "172.31.252.0/22"
  ]
}

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "vpc_one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  type        = bool
  default     = true
}
