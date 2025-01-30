output "id" {
  description = "The resource ID of the Container Registry."
  value       = azurerm_container_registry.this.id
}

output "login_server" {
  description = "The URL that can be used to log into the container registry."
  value       = azurerm_container_registry.this.login_server
}

output "identity" {
  description = "The identity associated with the container registry."
  value       = azurerm_container_registry.this.identity
}

#########################
### Private Endpoints ###
#########################

output "private_endpoint_ids" {
  description = "The Azure resource IDs of the private endpoints created."
  value = tomap({
    for k, v in azurerm_private_endpoint.this : k => v.id
  })
}

output "private_endpoint_ip_config" {
  description = "The IP configuration of the private endpoints."
  value = tomap({
    for k, v in azurerm_private_endpoint.this : k => v.id
  })
}

output "user_assigned_managed_identity_ids" {
  value = var.user_assigned_managed_identity_ids
}
