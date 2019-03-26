resource "azurerm_subnet" "redis_subnet" {
  name                 = "redis_subnet"
  address_prefix       = "192.1.0.0/24"
  resource_group_name  = "${data.azurerm_virtual_network.shared.resource_group_name}"
  virtual_network_name = "${data.azurerm_virtual_network.shared.name}"
}

resource "azurerm_virtual_machine_scale_set" "scaleset" {
  name                = "redis-cluster"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  upgrade_policy_mode = "Manual"
  overprovision       = false
  depends_on          = ["azurerm_subnet.redis_subnet"]

  sku {
    name     = "${var.redis_vm_sku}"
    tier     = "Standard"
    capacity = "${var.redis_vm_count}"
  }

  os_profile {
    computer_name_prefix = "redis-"
    admin_username       = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
        path     = "/home/azureuser/.ssh/authorized_keys"
        key_data = "${tls_private_key.vmss_key.public_key_openssh}"
    }
  }

  network_profile {
    name    = "redis-nic"
    primary = true

    ip_configuration {
      primary                                = true
      name                                   = "redis-ipconfig"
      subnet_id                              = "${azurerm_subnet.redis_subnet.id}"
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
    id="${data.azurerm_image.redis_image.id}"
  }
}