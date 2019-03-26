data "azurerm_image" "workers_image" {
  name                = "${var.workers_image_name}"
  resource_group_name = "${var.workers_image_resource_group_name}"
}

data "azurerm_image" "redis_image" {
  name                = "${var.redis_image_name}"
  resource_group_name = "${var.redis_image_resource_group_name}"
}

data "azurerm_key_vault" "shared" {
  name                = "${var.key_vault_name}"
  resource_group_name = "${var.key_vault_resource_group_name}"
}

data "azurerm_virtual_network" "shared" {
  name                = "${var.vnet_name}"
  resource_group_name = "${var.vnet_resource_group_name}"
}