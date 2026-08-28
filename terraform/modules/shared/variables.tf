variable "name" {
  type        = string
  description = "The name of the Key Vault. Must be globally unique across Azure, 3-24 characters, and contain only alphanumeric characters and hyphens."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Key Vault."
}

variable "location" {
  type        = string
  description = "The Azure region where the Key Vault should be created (e.g. \"westeurope\", \"norwayeast\")."
}

variable "rbac_authorization_enabled" {
  type        = bool
  default     = true
  description = "Whether Azure RBAC should be used for authorization of data actions on the Key Vault, instead of access policies. Recommended to be true for modern deployments."
}

variable "sku_name" {
  type        = string
  description = "The pricing tier / SKU of the Key Vault. Possible values are \"standard\" or \"premium\" (premium adds support for HSM-backed keys)."

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either \"standard\" or \"premium\"."
  }
}

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = false
  description = "Whether Azure Disk Encryption is permitted to retrieve secrets from the Key Vault and unwrap keys."
}

variable "soft_delete_retention_days" {
  type        = number
  description = "The number of days that items should be retained for once soft-deleted. Must be between 7 and 90."

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "purge_protection_enabled" {
  type        = bool
  default     = false
  description = "Whether purge protection is enabled for this Key Vault. Once enabled, this cannot be disabled and prevents permanent deletion of the vault or its contents during the retention period."
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the Key Vault."
}
