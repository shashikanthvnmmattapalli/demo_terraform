variable "name" {
  description = "The name of the virtual machine"
}

variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The location/region of the virtual machine"
}

variable "vm_size" {
  description = "The size of the virtual machine"
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
}

variable "subnet_id" {
  description = "The ID of the subnet to which the virtual machine should be connected"
}



variable "network_interface_id" {
  description = "The ID of the subnet to which the virtual machine should be connected"
}