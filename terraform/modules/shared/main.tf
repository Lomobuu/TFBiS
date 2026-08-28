data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key-vault" {
  ### Core
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  ### Required
  rbac_authorization_enabled  = var.rbac_authorization_enabled
  sku_name = var.sku_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  ### Optional Options
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled

  tags = var.tags
}