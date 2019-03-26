variable "tenant_id" {
  description = "Active Directory 'Directory ID' property."
}

variable "subscription_id" {}

variable "client_id" {
  description = "Application ID value from an Active Directory App Registration."
}

variable "client_secret" {
  description = "Secret value obtained by creating a key for the App Registration."
}

# Shared resources 

variable "vnet_resource_group_name" {}
variable "vnet_name" {}

variable "key_vault_resource_group_name" {}
variable "key_vault_name" {}

# Common properties

variable "resource_group_name" {
  description = "The name of the resource group used for the manager"
}

variable "location" {
  description = "The location/region where the manager resources are created"
}

# Redis VMs

variable "redis_image_name" {}
variable "redis_image_resource_group_name" {}

variable "redis_vm_sku" {
    default = "Standard_D2_v2"
}
variable "redis_vm_count" {
    default = "3"
}

# Worker VMs

variable "workers_image_name" {}
variable "workers_image_resource_group_name" {}

variable "workers_vm_sku" {
    default = "Standard_D2_v2"
}
variable "workers_vm_count" {
    default = "1"
}

# Shared secrets

variable "admin_username" {
    default = "azureuser"
}
variable "admin_ssh_key" {
    default = ""
}
