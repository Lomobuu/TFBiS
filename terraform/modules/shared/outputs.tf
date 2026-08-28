output "id" {
  value       = azurerm_key_vault.key-vault.id
  description = "The resource ID of the Key Vault. Useful for referencing the vault in RBAC role assignments, diagnostic settings, or other resources."
}

output "name" {
  value       = azurerm_key_vault.key-vault.name
  description = "The name of the Key Vault."
}

output "vault_uri" {
  value       = azurerm_key_vault.key-vault.vault_uri
  description = "The URI of the Key Vault (e.g. https://<name>.vault.azure.net/), used by applications and CLI tools to access secrets, keys, and certificates."
}
