variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure location for the resources"
  type        = string
  default     = "East US"
}

variable "subscription_id" {
  description = "The Azure subscription ID"
}