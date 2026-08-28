### Core

variable "name" {
  description = "AKS cluster name."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The name of the location to create the resources in."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}

### DNS set exactly one of the two (created module enforces via precondition)

variable "dns_prefix" {
  description = "DNS prefix for a public cluster. Set this OR dns_prefix_private_cluster."
  type        = string
  default     = null

  # Requires Terraform >= 1.9 for cross-variable references in validation.
  validation {
    condition     = (var.dns_prefix == null) != (var.dns_prefix_private_cluster == null)
    error_message = "Set exactly one of dns_prefix or dns_prefix_private_cluster (not both, not neither)."
  }
}

variable "dns_prefix_private_cluster" {
  description = "DNS prefix for a private cluster. Set this OR dns_prefix."
  type        = string
  default     = null
}

### Cluster settings

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "SKU tier for the cluster (Free, Standard, Premium)."
  type        = string
  default     = "Free"
}

### Feature toggles

variable "azure_policy_enabled" {
  description = "Enable the Azure Policy add-on."
  type        = bool
  default     = false
}

variable "oidc_issuer_enabled" {
  description = "Enable the OIDC issuer (required for Workload Identity)."
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Enable Workload Identity."
  type        = bool
  default     = true
}

variable "role_based_access_control_enabled" {
  description = "Enable Kubernetes RBAC."
  type        = bool
  default     = true
}

### Default (system) node pool
# Per-environment overrides MUST supply every field below (set unused ones
# to null). Fields you'll almost always set: name, vm_size, and the
# autoscaling trio (auto_scaling_enabled / min_count / max_count) or node_count.

variable "default_node_pool" {
  description = "Configuration for the system / default node pool. All fields required when overriding."
  type = object({
    name                         = string
    vm_size                      = string
    type                         = string
    node_count                   = number
    auto_scaling_enabled         = bool
    min_count                    = number
    max_count                    = number
    max_pods                     = number
    os_disk_size_gb              = number
    os_sku                       = string
    vnet_subnet_id               = string
    zones                        = list(string)
    node_labels                  = map(string)
    only_critical_addons_enabled = bool
    orchestrator_version         = string
    temporary_name_for_rotation  = string
  })

  default = {
    name                         = "system"
    vm_size                      = "Standard_D2s_v5"
    type                         = "VirtualMachineScaleSets"
    node_count                   = null
    auto_scaling_enabled         = true
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 30
    os_disk_size_gb              = 128
    os_sku                       = "Ubuntu"
    vnet_subnet_id               = null
    zones                        = null
    node_labels                  = {}
    only_critical_addons_enabled = false
    orchestrator_version         = null
    temporary_name_for_rotation  = null
  }

  # When autoscaling is on, min/max must be set.
  validation {
    condition = (
      var.default_node_pool.auto_scaling_enabled == false
      ) || (
      var.default_node_pool.min_count != null &&
      var.default_node_pool.max_count != null &&
      var.default_node_pool.min_count <= var.default_node_pool.max_count
    )
    error_message = "When auto_scaling_enabled = true, min_count and max_count must be set and min_count <= max_count."
  }
}

# Node provisioning profile 

variable "node_provisioning_profile" {
  description = "Node provisioning profile. mode = 'Manual' or 'Auto'."
  type = object({
    mode = string
  })
  default  = { mode = "Manual" }
  nullable = false
}

### Upgrade settings

variable "upgrade_settings" {
  description = "Node pool upgrade settings"
  type = object({
    max_surge                     = optional(string, "10%")
    drain_timeout_in_minutes      = optional(number, 0)
    node_soak_duration_in_minutes = optional(number, 0)
  })
  default = {}
}

### Identity OR service principal, set exactly one

variable "identity" {
  description = "Managed identity block. Set this OR service_principal."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = null
  }
}

variable "service_principal" {
  description = "Service principal block. Set this OR identity."
  type = object({
    client_id     = string
    client_secret = string
  })
  default = null
}

### Entra ID (AAD) integration for Kubernetes RBAC

variable "aad_rbac_enabled" {
  description = "Enable Entra ID integration for Kubernetes RBAC."
  type        = bool
  default     = true
}

variable "aad_rbac" {
  description = "Entra ID RBAC configuration. Used only when aad_rbac_enabled = true. All fields required when overriding."
  type = object({
    tenant_id              = string
    admin_group_object_ids = list(string)
    azure_rbac_enabled     = bool
  })
  default = {
    tenant_id              = null
    admin_group_object_ids = []
    azure_rbac_enabled     = true
  }
}

### Key Vault Secrets Provider (CSI)

variable "key_vault_secrets_provider_enabled" {
  description = "Enable the Key Vault Secrets Provider (CSI) add-on."
  type        = bool
  default     = true
}

variable "key_vault_secrets_provider" {
  description = "Key Vault Secrets Provider configuration. Used only when enabled. All fields required when overriding."
  type = object({
    secret_rotation_enabled  = bool
    secret_rotation_interval = string
  })
  default = {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
}
