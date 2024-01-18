resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku              = "Standard"
}

output "public_ip_id" {
  value = azurerm_public_ip.public_ip.id
}