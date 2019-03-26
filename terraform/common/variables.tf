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

variable "resource_group_name" {
  description = "The name of the resource group used for the manager"
}

variable "location" {
  description = "The location/region where the manager resources are created"
}

variable "vnet_name" {}

variable "key_vault_name" {}
