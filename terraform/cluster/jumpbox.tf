resource "azurerm_public_ip" "pip" {
  name                         = "${azurerm_resource_group.rg.name}-pip"
  location                     = "${azurerm_resource_group.rg.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  domain_name_label            = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "jumpbox-nic"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.workers.id}"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "jumpbox" {
  name                  = "jumpbox-vm"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.jumpbox.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7-CI"
    version   = "latest"
  }
  storage_os_disk {
    name              = "disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "jumpbox"
    admin_username = "azureuser"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
        path     = "/home/azureuser/.ssh/authorized_keys"
        key_data = "${var.admin_ssh_key}"
    }    
  }
}