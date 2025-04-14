#################
### Providers ###
#################

provider "azurerm" {
  features {}
}

####################################
### Azure Resource Prerequisites ###
####################################

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "canada central"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["172.16.0.0/16"]
  location            = "Canada Central"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "registry" {
  name                 = "registry"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["172.16.1.0/24"]
}

resource "azurerm_resource_group" "management" {
  name     = "network-management-rg"
  location = "Canada Central"
}

resource "azurerm_private_dns_zone" "acr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.management.name
}

########################
### Key Vault Module ###
########################

module "container_registry" {
  source = "../../"

  naming_convention = "gc"
  user_defined      = "example"

  azure_resource_attributes = {
    department_code = "Gc"
    owner           = "ABC"
    project         = "aur"
    environment     = "dev"
    location        = azurerm_resource_group.example.location
    instance        = 0
  }

  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "Premium"

  public_network_access_enabled = false
  private_endpoints = [
    {
      subnet_id           = azurerm_subnet.registry.id
      private_dns_zone_id = azurerm_private_dns_zone.acr.id
    }
  ]

  tags = {
    env = "development"
  }

  depends_on = [azurerm_private_dns_zone.acr]
}
