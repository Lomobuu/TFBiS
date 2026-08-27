resource "random_id" "this" {
  byte_length = 8
}

module "storage" {
  source = "github.com/Lomobuu/TFModule-Storage"

  account_name               = "st${random_id.this.hex}"
  resource_group_name        = var.resource_group_name
  location                   = var.location

  is_hns_enabled = true
  shared_access_key_enabled = true

}