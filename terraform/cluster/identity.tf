resource "azurerm_user_assigned_identity" "workers_identity" {
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  name                = "workers_identity"
}

resource "azurerm_key_vault_access_policy" "readpolicy" {
  vault_name          = "${data.azurerm_key_vault.shared.name}"
  resource_group_name = "${data.azurerm_key_vault.shared.resource_group_name}"

  key_permissions = []

  secret_permissions = [
    "get",
  ]

  certificate_permissions = [
    "get",
  ]

  tenant_id = "${var.tenant_id}"
  object_id = "${azurerm_user_assigned_identity.workers_identity.principal_id}"
}
