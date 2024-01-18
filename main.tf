module "resource_group" {
  source              = "./modules/resource_group"  # Replace with the actual path or URL to your module
  resource_group_name = "ddm-rg"
  location            = "East US"
}

module "virtual_network" {
  source              = "./modules/virtual_network"
  name                = "ddm_vpc"
  resource_group_name = module.resource_group.resource_group_name
  location            = "East US"
  address_space       = ["10.0.0.0/16"]
}

module "subnet" {
  source               = "./modules/subnets"
  name                 = "ddm_subnet"
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.virtual_network.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
}

module "public_ip" {
  source              = "./modules/public_address"
  resource_group_name = module.resource_group.resource_group_name
  location            = "East US"
  public_ip_name      = "ddm_public_ip"
}

module "network_nic" {
  nicname                = "ddm_nic1"
  source              = "./modules/network_interface"
  resource_group_name = module.resource_group.resource_group_name
  location            = "East US"
  subnet_id          = module.subnet.subnet_id
  
}

module "network_nic_1" {
  nicname                = "ddmnic2"
  source              = "./modules/network_interface"
  resource_group_name = module.resource_group.resource_group_name
  location            = "East US"
  subnet_id          = module.subnet.subnet_id
  
}
module "agw_subnet" {
  source               = "./modules/subnets"
  name                 = "agw-subnet"
  resource_group_name  = module.resource_group.resource_group_name
  virtual_network_name = module.virtual_network.virtual_network_name
  address_prefixes     = ["10.0.0.0/24"]
}

module "virtual_machine1" {
  source              = "./modules/virtual_machines"
  name                = "vm1"
  resource_group_name  = module.resource_group.resource_group_name
  location            = "East US"
  vm_size             = "Standard_DS1_v2"  # Specify the desired VM size
  subnet_id            = module.subnet.subnet_id
  admin_username       = "admin01"
  admin_password       = "Bachupally@2023"
  network_interface_id = module.network_nic.network_interface_id
}

module "virtual_machine2" {
 source              = "./modules/virtual_machines"
  name                = "vm2"
  resource_group_name  = module.resource_group.resource_group_name
  location            = "East US"
  vm_size             = "Standard_DS2_v2"  # Specify the desired VM size
  subnet_id            = module.subnet.subnet_id
  admin_username       = "admin01"
  admin_password       = "Bachupally@2023"
  network_interface_id = module.network_nic_1.network_interface_id

}

module "apgw" {
  source                   = "./modules/application_gateway"
  application_gateway_name = "ddm_apwg"
  resource_group_name      = module.resource_group.resource_group_name
  location                 = "East US"
  public_id                = module.public_ip.public_ip_id
  subnet_id                = module.agw_subnet.subnet_id
  frontend_port_name       = [{
    name = "ddm_frontend_port"
    port = 80
  },
  {
    name = "ddm_frontend_port1"
    port = 8080
  }]
  backend_address_pool_name  = ["ddm_backend_pool_images", "ddm_backend_pool_videos"]

  frontend_ip_configuration_name = [
    {
      name                 = "ddm_Config"
      public_ip_address_id = module.public_ip.public_ip_id
    },
  ]

  http_setting_name = [
    {
      name                  = "ddmHTTPsetting_images"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 60
    },
    {
      name                  = "ddmHTTPsetting_videos"
      cookie_based_affinity = "Disabled"
      port                  = 80
      protocol              = "Http"
      request_timeout       = 60
    },
  ]

  listener_name = [
    {
      name                           = "ddmListener_images"
      frontend_ip_configuration_name = "ddm_Config"
      frontend_port_name              = "ddm_frontend_port"
    },
    {
      name                           = "ddmListener_videos"
      frontend_ip_configuration_name = "ddm_Config"
      frontend_port_name              = "ddm_frontend_port1"
    }
  ]

  request_routing_rule_name = [
    {
      name                        = "ddmRoutingRule_images"
      rule_type                   = "PathBasedRouting"
      http_listener_name          = "ddmListener_images"
      backend_address_pool_name   = "ddm_backend_pool_images"
      backend_http_settings_name  = "ddmHTTPsetting_images"
      priority                    = 1
      url_path_map_name           = "ddm_images"
      
    },
  ]

  url_path_maps = [
    {
      name                               = "ddm_images"
      default_backend_http_settings_name = "ddmHTTPsetting_images"
      default_backend_address_pool_name  = "ddm_backend_pool_images"
      path_rules = [
        {
          name                       = "images"
          paths                      = ["/images/*"]
          backend_address_pool_name = "ddm_backend_pool_images"
          backend_http_settings_name = "ddmHTTPsetting_images"
        },
        {
          
          name                       = "videos"
          paths                      = ["/videos/*"]
          backend_address_pool_name = "ddm_backend_pool_videos"
          backend_http_settings_name = "ddmHTTPsetting_videos"
        
        },
        # Add more path_rules as needed
      ]
    },
    # Add more url_path_maps as needed
  ]
}

module "backend_target_nic1_pool1" {
  source = "./modules/backend_pools"
  ip_configuration_name = "nic-ipconfig"
  network_interface_id = module.network_nic.network_interface_id
  backend_address_pool_id = module.apgw.backend_address_pool_id[0]
}

module "backend_target_nic1_pool2" {
  source = "./modules/backend_pools"
  ip_configuration_name = "nic-ipconfig"
  network_interface_id = module.network_nic_1.network_interface_id
  backend_address_pool_id = module.apgw.backend_address_pool_id[1]
}


 



  