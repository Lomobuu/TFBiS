### Shared resources
locals {
  resource_group_name = "rg-myapp-dev"
  location            = "norwayeast"
}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}
#### Storage Account
module "data" {
  source = "../../modules/data"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
}


### Key Vault
module "keyvault" {
  source = "../../modules/shared"

  name                = "kv-fznmyapp-dev" # or your own naming convention
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
  sku_name            = "standard"
  rbac_authorization_enabled  = true
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  enabled_for_disk_encryption = false

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    newtag      = "tagtest"
  }
}

#### Managed Identity for Key Vault access via Workload Identity
resource "azurerm_user_assigned_identity" "keyvault_workload" {
  name                = "id-keyvault-workload-dev"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
}

resource "azurerm_role_assignment" "keyvault_secrets_user" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.keyvault_workload.principal_id
}



### AKS
module "aks" {
  source = "../../modules/aks"

  name                = "aks-myapp-dev"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location

  # Public cluster pick exactly one DNS option
  dns_prefix = "aks-myapp-dev"
  oidc_issuer_enabled = true
  workload_identity_enabled = true

  # Environment-specific node sizing
  default_node_pool = {
    name                         = "system"
    vm_size                      = "Standard_L2s_v4" # was Standard_D2s_v5
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

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
