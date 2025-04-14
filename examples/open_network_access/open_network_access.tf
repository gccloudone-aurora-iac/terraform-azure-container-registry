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
