variable "spn-client-id" {
   type = string
   description = "Client ID for SPN to authenticate"
}

variable "spn-client-secret" {
  type = string
  description = "Client secret for SPN to authenticate"
}

variable "spn-tenant-id" {
   type = string
   description = "Tenant ID for SPN to authenticate"
}

variable "resource_group_name" {
   type = string
   description = "name of the resource group"
}
variable "location" {
 type = string
 description = "location"
}

variable "virtual_network_name" {
   type = string
   description = "Name of the virtual network"
}


variable "virtual_network_location" {
   type = string
   description = "Location of the virtual network"
}

variable "virtual_network_address_space" {
   type = list(string)
   description = "Address Space"
}


variable "subnet1_name" {
   type = string
   description = "Name of the subnet"
}


variable "subnet1_address_space" {
   type = list(string)
   description = "Address Space of subnet1"
}

variable "subnet2_name" {
   type = string
   description = "Name of the subnet2"
}


variable "subnet2_address_space" {
   type = list(string)
   description = "Address Space of subnet2"
}

variable "storage_account_name" {
   type = string
   description = "Storage account name"
}


variable "key_vault_name" {
   type = string
   description = "Key vault name"
}

variable "key_vault_rsg_name" {
   type = string
   description = "Key vault Resource group name"
}


variable "VM1_name" {
   type = string
   description = "VM1 Name"
}


variable "VM2_name" {
   type = string
   description = "VM2 Name"
}
