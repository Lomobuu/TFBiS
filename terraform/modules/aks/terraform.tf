terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.2.0"
    }
  }

  backend "azurerm" {
    # left empty on purpose — values are injected via -backend-config
  }
}