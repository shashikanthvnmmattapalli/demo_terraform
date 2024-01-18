variable "application_gateway_name" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
}

variable "backend_address_pool_name" {
    type = list(string)
}

variable "frontend_port_name" {
    type = list(map(string))
}

variable "frontend_ip_configuration_name" {
    type = list(map(string))
}

variable "http_setting_name" {
    type = list(map(string))
}

variable "listener_name" {
    type = list(map(string))
}

variable "request_routing_rule_name" {
    type = list(object({
        name                       = string
        rule_type                  = string
        http_listener_name         = string
        priority                   = number
        backend_address_pool_name  = string
        backend_http_settings_name = string
        url_path_map_name          = string

    }))
}

variable "public_id" {}

variable "subnet_id" {}

variable "url_path_maps" {
  type = list(object({
    name                             = string
    default_backend_http_settings_name = string
    default_backend_address_pool_name  = string
    path_rules                        = list(object({
      name                       = string
      paths                      = list(string)
      backend_address_pool_name = string
      backend_http_settings_name = string
    }))
  }))
}





