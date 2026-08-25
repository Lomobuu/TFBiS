locals {
  resource_group_name = "rg-myapp-dev"
  location             = "norwayeast"
}

data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

module "data" {
  source = "../../modules/data"

  resource_group_name = data.azurerm_resource_group.this.name
  location            = local.location
}