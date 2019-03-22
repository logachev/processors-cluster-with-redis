resource "azurerm_subnet" "workers" {
  name                 = "workers_subnet"
  address_prefix       = "192.2.0.0/16"
  resource_group_name  = "${data.azurerm_virtual_network.shared.resource_group_name}"
  virtual_network_name = "${data.azurerm_virtual_network.shared.name}"
}

resource "azurerm_virtual_machine_scale_set" "workers" {
  name                = "workers-cluster"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  upgrade_policy_mode = "Manual"
  overprovision       = false
  depends_on          = ["azurerm_subnet.workers"]

  sku {
    name     = "${var.workers_vm_sku}"
    tier     = "Standard"
    capacity = "${var.workers_vm_count}"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = ["${azurerm_user_assigned_identity.workers_identity.id}"]
  }

  extension {
    name                 = "MSILinuxExtension"
    publisher            = "Microsoft.ManagedIdentity"
    type                 = "ManagedIdentityExtensionForLinux"
    type_handler_version = "1.0"
    settings             = "{\"port\": 50342}"
  }

  os_profile {
    computer_name_prefix = "workers-"
    admin_username       = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
        path     = "/home/azureuser/.ssh/authorized_keys"
        key_data = "${var.admin_ssh_key}"
    }
  }

  network_profile {
    name    = "workers-nic"
    primary = true

    ip_configuration {
      primary                                = true
      name                                   = "workers-ipconfig"
      subnet_id                              = "${azurerm_subnet.workers.id}"
    }
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  storage_profile_image_reference {
    id="${data.azurerm_image.workers_image.id}"
  }
}