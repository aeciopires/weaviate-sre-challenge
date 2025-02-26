################################################################################
# General
################################################################################
aws_profile    = "myaccount"
aws_account_id = "CHANGE_HERE"
region         = "us-east-2"
aws_default_tags = {
  environment = "testing",
  terraform   = "true",
  scost       = "customer-xpto",
}
namespace = "weaviate"
key_name  = "key-gyr4"

# For create key pair RSA (without passphrase):
# ssh-keygen -t rsa -b 4096 -v -f ~/key-gyr4.pem
# Copy content public key without USER and HOST.
# cat ~/key-gyr4.pem.pub | cut -d " " -f1,2
public_key_content = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGaj/Af6UpsosJoP7Z3AEW6qf+9qQsIpYhbWR9ZXfo0M5/HorpCe/OqqyMwjLwfZb6TCDKDjH/9MK5Y3VxoL/SF/ECjk3SJM5NQO/NWZojZUYM8nTkkc0sqsF7MNJgN4I0SFeigJwWpYE2h0NAJTadMIt9jY9OAEcH1FIcpcBgE9SuL4SvZm7CDbBlSloMoGqBS+BB/9sHc7UCANFR0FrAFdwMKGYUmlOmMJlklbryoSuht8A5fWGo+iPtkksVgJ07fIlnkDiFhJIiaM4ScEd5g8OwjrmZjfx4+pyQlEAXKiYwR5T/05gHomMCNdUZfLjIAzLRlcaRTxQ6CVhRUlB4KYcoYdpc8sbw8stVh6p0uRUZ9O+cKoEcyQv8gq0pUoq+er3+inHIlcUY+nLNPGFRlRcWzZ0Dd96QeJclEByln7vRVZDokKyn1y41P/jV2FtXdt/z/MbCYxhqtWxXQtDpIuauW6aPU9CDyjPgif3KjluxILYH7lyw8uKJuJM3pV0S15ZVdu6a3GeVrGRYMx4Gq6QyFcc9Rtl3E1QhFFxXWFvpMkIfeiax5HfQHE+XHWKN38LXR+8ZjQbMZSD/8/WJP2K9YVLIsRfLclwwkccYGEvMfiQuDIx7YjLZ+lF8WBGNUswbibDhiDK9aQLZ0n4bvGRrPtWgbE5oJm8AjeQi2w=="


################################################################################
# EKS cluster
################################################################################
eks_cluster_enabled_log_types            = ["authenticator"]
eks_cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
eks_cluster_name                         = "cluster1-gyr4"
eks_cluster_version                      = "1.32"


################################################################################
# CloudWatch Log Group
################################################################################
eks_cloudwatch_log_group_retention_in_days = 7


################################################################################
# KMS Key
################################################################################
create_kms_key                  = true
kms_key_description             = "General KMS encryption key"
kms_key_deletion_window_in_days = 7
enable_kms_key_rotation         = false
kms_key_aliases                 = ["alias/customer-xpto-testing"]


################################################################################
# VPC
################################################################################
vpc_name = "net-gyr4"
# http://jodies.de/ipcalc?host=172.31.240.0&mask1=20&mask2=22
vpc_cidr = "172.31.240.0/20"
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
vpc_azs = [
  "use2-az1",
  "use2-az2"
]
vpc_public_subnets = [
  "172.31.240.0/22",
  "172.31.244.0/22"
]
vpc_private_subnets = [
  "172.31.248.0/22",
  "172.31.252.0/22"
]
vpc_single_nat_gateway     = false
vpc_one_nat_gateway_per_az = true
