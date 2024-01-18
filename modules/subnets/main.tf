# modules/subnet/main.tf
resource "azurerm_subnet" "sub" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes
}

output "subnet_name" {
  value = azurerm_subnet.sub.name
}

output "subnet_id" {
  value = azurerm_subnet.sub.id
}
