resource "azurerm_application_gateway" "main" {
  name                = var.application_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port_name
    content {
    name = frontend_port.value.name
    port = frontend_port.value.port
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configuration_name
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool_name
    content {
      name = backend_address_pool.value
    }
  }

  dynamic backend_http_settings {
    for_each  = var.http_setting_name
    content {
      name                  = backend_http_settings.value.name   
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic http_listener {
    for_each   = var.listener_name
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name 
      protocol                       = "Http"
    }
  }

 dynamic "request_routing_rule" {
    for_each = var.request_routing_rule_name
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      priority                   = request_routing_rule.value.priority
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
      url_path_map_name          = request_routing_rule.value.url_path_map_name
   

    }
  
    
    

  }



 dynamic "url_path_map" {
  for_each = var.url_path_maps
  content {
    name = url_path_map.value.name
    default_backend_http_settings_name = url_path_map.value.default_backend_http_settings_name
    default_backend_address_pool_name  = url_path_map.value.default_backend_address_pool_name
    dynamic "path_rule" {
      for_each = url_path_map.value.path_rules

      content {
       name                       = path_rule.value.name
       paths                      = path_rule.value.paths
       backend_address_pool_name = path_rule.value.backend_address_pool_name
       backend_http_settings_name = path_rule.value.backend_http_settings_name
      

    }
  }
  }  
 }

}

output "backend_pool_ids" {
  value = {
    for pool in azurerm_application_gateway.main.backend_address_pool : 
      pool.name => pool.id
  }
}


