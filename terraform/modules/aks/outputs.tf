output "id" {
  description = "Resource ID of the AKS cluster."
  value       = module.aks.id
}

output "name" {
  description = "Name of the AKS cluster."
  value       = module.aks.name
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL (used for Workload Identity federation)."
  value       = module.aks.oidc_issuer_url
}

output "kubelet_identity" {
  description = "Kubelet identity object (client_id, object_id, user_assigned_identity_id). Useful for Key Vault RBAC grants."
  value       = module.aks.kubelet_identity
}

output "key_vault_secrets_provider_identity" {
  description = "Managed identity used by the Key Vault Secrets Provider add-on, when enabled."
  value       = module.aks.key_vault_secrets_provider_identity
}

output "node_resource_group" {
  description = "Auto-generated resource group holding the node pool infrastructure."
  value       = module.aks.node_resource_group
}

output "kube_config_raw" {
  description = "Raw kubeconfig for the cluster."
  value       = module.aks.kube_config_raw
  sensitive   = true
}