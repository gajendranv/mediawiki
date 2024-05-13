provider "azurerm" { 
  features {} 
  }

resource "azurerm_resource_group" "example" {
  name     = "demoresourcegp"
  location = "Central India"
}

resource "azurerm_container_registry" "acr" {
  name                = "democontainerBCF"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = false
#   georeplications {
#     location                = "East US"
#     zone_redundancy_enabled = true
#     tags                    = {}
#   }
#   georeplications {
#     location                = "North Europe"
#     zone_redundancy_enabled = true
#     tags                    = {}
#   }
}

