provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  name                = "${var.vnet_name}"
  location            = "${azurerm_resource_group.rg.location}"

  address_space       = ["192.0.0.0/8"]
}

resource "azurerm_key_vault" "kv" {
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  name                        = "${var.key_vault_name}"
  location                    = "${azurerm_resource_group.rg.location}"
  tenant_id                   = "${var.tenant_id}"

  enabled_for_disk_encryption = true
  sku {
    name = "standard"
  }
}