terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.56.0"
   }
 }
}

provider "azurerm" {
   features {}
   subscription_id = "9b30d50f-1a4a-4247-92c6-f0784dd56139"
   client_id = var.spn-client-id
   client_secret = var.spn-client-secret
   tenant_id = var.spn-tenant-id
}