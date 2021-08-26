terraform {
   backend "azurerm" {
       storage_account_name = "terraformstorc0de4dev"
       container_name = "tfstate"
       key = "demo.terraform.tfstate"
   }
}