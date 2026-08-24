variable "resource_group_name" {
  description = "The name of the resource group to create the resources in."
  type        = string
}

variable "location" {
  description = "The name of the location to create the resources in."
  type        = string
}

variable "account_name" {
  description = "The name of this Storage account."
  type        = string
  nullable    = false
}

variable "container_name" {
  description = "The name of the container inside the storage account."
  type    = string
  default = "tfstate"
}