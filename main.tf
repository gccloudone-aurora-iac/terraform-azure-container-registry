#########
## ACR ##
#########

module "container_registry_name" {
  source = "git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names-global.git?ref=v2.0.0"

  user_defined = var.user_defined
}

resource "azurerm_container_registry" "this" {
  name                = module.container_registry_name.container_registry_name
  resource_group_name = var.resource_group_name
  location            = var.azure_resource_attributes.location
  sku                 = var.sku_name

  # Network
  data_endpoint_enabled         = var.data_endpoint_enabled # Only premeium
  export_policy_enabled         = var.export_policy_enabled # Only premeium
  public_network_access_enabled = var.public_network_access_enabled
  network_rule_bypass_option    = var.network_rule_bypass_option
  network_rule_set { # Only premeium
    default_action = var.default_network_access_action

    ip_rule = [
      for ip_range in var.ip_rules : {
        action   = "Allow"
        ip_range = ip_range
      }
    ]

    virtual_network = [
      for subnet_id in var.service_endpoint_subnet_ids : {
        action    = "Allow"
        subnet_id = subnet_id
      }
    ]
  }

  # Availability
  zone_redundancy_enabled = var.zone_redundancy_enabled # Only premeium
  dynamic "georeplications" {                           # Only premeium
    for_each = var.georeplications
    content {
      location                  = georeplications.value.location
      zone_redundancy_enabled   = georeplications.value.zone_redundancy_enabled
      regional_endpoint_enabled = georeplications.value.regional_endpoint_enabled
      tags                      = local.tags
    }
  }
  dynamic "retention_policy" {
    for_each = var.retention_policy_days != null ? ["retention_policy"] : [] # Only premeium
    content {
      enabled = true
      days    = var.retention_policy_days
    }
  }

  # Security
  admin_enabled             = var.admin_enabled
  anonymous_pull_enabled    = var.anonymous_pull_enabled
  quarantine_policy_enabled = var.quarantine_policy_enabled # Only premeium
  dynamic "trust_policy" {                                  # Only premeium
    for_each = var.trust_policy_enabled ? ["trust_policy"] : []
    content {
      enabled = var.trust_policy_enabled
    }
  }
  dynamic "encryption" {
    for_each = var.cmk_encryption != null ? ["encryption"] : []
    content {
      enabled            = true
      key_vault_key_id   = encryption.value.key_vault_key_id
      identity_client_id = encryption.value.identity_client_id
    }
  }

  identity {
    type         = var.user_assigned_managed_identity_ids == null ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.user_assigned_managed_identity_ids
  }

  tags = local.tags
}

#########################
### Private Endpoints ###
#########################

resource "azurerm_private_endpoint" "this" {
  for_each = { for index, endpoint in var.private_endpoints : index => endpoint }

  name                = "${module.azure_resource_names.private_endpoint_name}-${var.user_defined}-${each.value.sub_resource_name}"
  location            = var.azure_resource_attributes.location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value.subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  private_service_connection {
    name                           = "${module.azure_resource_names.private_endpoint_name}-${var.user_defined}-${each.value.sub_resource_name}"
    private_connection_resource_id = azurerm_container_registry.this.id
    is_manual_connection           = false
    subresource_names              = [each.value.sub_resource_name]
  }

  tags = local.tags
}
