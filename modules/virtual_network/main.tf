resource "azurerm_virtual_network" "vpc" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vpc.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vpc.id
}
