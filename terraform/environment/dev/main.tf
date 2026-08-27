### Shared resources
locals {
  resource_group_name = "rg-myapp-dev"
  location            = "norwayeast"
}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}
### Storage Account
module "data" {
  source = "../../modules/data"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
}

### AKS
module "aks" {
  source = "../../modules/aks"

  name                = "aks-myapp-dev"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location

  # Public cluster pick exactly one DNS option
  dns_prefix = "aks-myapp-dev"

  # Environment-specific node sizing
  default_node_pool = {
    name                         = "node_pool_name"
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
