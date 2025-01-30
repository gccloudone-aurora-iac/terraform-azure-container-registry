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

########################
### Key Vault Module ###
########################

module "container_registry" {
  source = "../../"

  azure_resource_attributes = {
    project     = "aur"
    environment = "dev"
    location    = azurerm_resource_group.example.location
    instance    = 0
  }
  user_defined        = "example"
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "Standard"

  public_network_access_enabled = true
  default_network_access_action = "Allow"

  tags = {
    env = "development"
  }
}

output "test" {
  value = module.container_registry.user_assigned_managed_identity_ids
}
