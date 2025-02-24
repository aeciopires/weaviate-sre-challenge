output "cluster_name" {
  description = "Name for EKS control plane."
  value       = module.weaviate_eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.weaviate_eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.weaviate_eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "cluster iam role name."
  value       = module.weaviate_eks.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  description = "cluster iam role arn."
  value       = module.weaviate_eks.cluster_iam_role_arn
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN."
  value       = module.weaviate_eks.oidc_provider_arn
}

output "node_security_group_id" {
  description = "ID of the node shared security group."
  value       = module.weaviate_eks.node_security_group_id
}
