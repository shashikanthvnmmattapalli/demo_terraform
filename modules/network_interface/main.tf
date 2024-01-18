resource "azurerm_network_interface" "nic" {

  name                = var.nicname
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "nic-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}



output "network_interface_id" {
  value = azurerm_network_interface.nic.id
  
}

