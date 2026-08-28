module "aks" {
  source = "github.com/Lomobuu/TFModule-AKS"

  ### Core
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = var.tags

  ### DNS, exactly one is non-null (enforced by validation on dns_prefix)
  dns_prefix                 = var.dns_prefix
  dns_prefix_private_cluster = var.dns_prefix_private_cluster

  ### Cluster settings
  kubernetes_version = var.kubernetes_version
  sku_tier           = var.sku_tier

  ### Feature toggles
  azure_policy_enabled              = var.azure_policy_enabled
  oidc_issuer_enabled               = var.oidc_issuer_enabled
  workload_identity_enabled         = var.workload_identity_enabled
  role_based_access_control_enabled = var.role_based_access_control_enabled

  ### System / default node pool
  default_node_pool = var.default_node_pool

  ### Node provisioning (null = omit block; created module defaults to Manual)
  node_provisioning_profile = var.node_provisioning_profile

  ### Upgrade Settings (resets to default if not added)
  upgrade_settings = var.upgrade_settings

  ### Identity OR service principal, exactly one (enforced by created module)
  identity          = var.identity
  service_principal = var.service_principal

  ### Entra ID (AAD) integration for Kubernetes RBAC
  aad_rbac_enabled = var.aad_rbac_enabled
  aad_rbac         = var.aad_rbac

  ### Key Vault Secrets Provider (CSI) add-on
  key_vault_secrets_provider_enabled = var.key_vault_secrets_provider_enabled
  key_vault_secrets_provider         = var.key_vault_secrets_provider

}