# ./modules/virtual_machine/main.tf


resource "azurerm_virtual_machine" "vm" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  vm_size               = var.vm_size

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.name
    admin_username = "admin01"
    admin_password = "Bachupally@2023"
  }

  storage_os_disk {
    name              = "${var.name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  network_interface_ids = [var.network_interface_id]

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

output "virtual_machine_name" {
  value = azurerm_virtual_machine.vm.name
}

output "virtual_machine_id" {
  value = azurerm_virtual_machine.vm.id
}

