# TODO USE BICEP TO SETUP BACKEND BECAUSE THIS IS HARDCODED...
variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
  default = "rg-vsps-tfstate-mgmt-weu-001"
}

variable "location" {
  description = "The name of the location to create the resources in."
  type        = string
  default = "westeurope"
}

variable "account_name" {
  description = "The name of this Storage account."
  type        = string
  nullable    = false
  default = "stvspstfstateweu001"
}

variable "container_name" {
  description = "The name of the container inside the storage account."
  type        = string
  default     = "tfstate"
}