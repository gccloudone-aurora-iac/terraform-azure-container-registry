variable "azure_resource_attributes" {
  description = "Attributes used to describe Azure resources"
  type = object({
    department_code = string
    owner           = string
    project         = string
    environment     = string
    location        = optional(string, "Canada Central")
    instance        = number
  })
  nullable = false
}

variable "user_defined" {
  description = "A user-defined field that describes the Azure resource."
  type        = string
  nullable    = false

  validation {
    condition     = length(var.user_defined) >= 2 && length(var.user_defined) <= 15
    error_message = "The user-defined field must be between 2-15 characters long."
  }
}

variable "naming_convention" {
  type        = string
  default     = "oss"
  description = "Sets which naming convention to use. Accepted values: oss, gc"
  validation {
    condition     = var.naming_convention == "oss" || var.naming_convention == "gc"
    error_message = "The naming_convention field must either be 'oss' or 'gc'."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which resources will be created"
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  type        = string
}

variable "tags" {
  description = "Tags to set on the Azure Container Registry."
  type        = map(string)
  default     = {}
}

##################
### Networking ###
##################

variable "data_endpoint_enabled" {
  description = "Whether to enable dedicated data endpoints for this Container Registry? This is only supported on resources with the Premium SKU."
  type        = bool
  default     = false
}

variable "export_policy_enabled" {
  description = "To prevent registry users in an organization from maliciously or accidentally leaking artifacts outside a virtual network, you can configure the registry's export policy to disable exports. Set to false to prevent the export of artifacts from a network-restricted registry. In order to set it to false, make sure the public_network_access_enabled is also set to false."
  type        = bool
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether public network access is allowed for this Container Registry. If false, only private endpoints can be created."
  type        = bool
  default     = false
}

variable "network_rule_bypass_option" {
  description = "Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices."
  type        = string
  default     = "AzureServices"
}

variable "default_network_access_action" {
  description = "The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
  type        = string
  default     = "Deny"
}

variable "ip_rules" {
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Container Registry."
  type        = set(string)
  default     = []
}

variable "service_endpoint_subnet_ids" {
  description = "The service endpoints to configure on the Container Registry."
  type        = set(string)
  default     = []
}

variable "private_endpoints" {
  description = "The information required to create a private endpoint for the Container Registry."
  type = list(object({
    sub_resource_name   = optional(string, "registry")
    subnet_id           = string
    private_dns_zone_id = string
  }))
  default = []

  validation {
    condition = alltrue([
      for entry in var.private_endpoints :
      contains(["registry"], entry.sub_resource_name)
    ])
    error_message = "Invalid sub_resource_name within var.private_endpoints. Expected the name to be 'registry'."
  }

  validation {
    condition = alltrue([
      for entry in var.private_endpoints :
      element(split("/", entry.private_dns_zone_id), 8) == "privatelink.azurecr.io"
    ])
    error_message = "Invalid private_dns_zone_id attribute within var.private_endpoints. Expected a Private DNS Zone with the name 'privatelink.azurecr.io'"
  }
}

################################
### Availability & Retention ###
################################

variable "zone_redundancy_enabled" {
  description = "Whether zone redundancy is enabled for this replication location?"
  type        = bool
  default     = false
}

variable "georeplications" {
  description = "Whether to geo-replicate the artifacts. The georeplications is only supported on new resources with the Premium SKU & the georeplications list cannot contain the location where the Container Registry exists."
  type = list(object({
    location                  = string
    zone_redundancy_enabled   = optional(bool, false)
    regional_endpoint_enabled = optional(bool, false)
  }))
  default = []
}

variable "retention_policy_days" {
  description = "Set a retention policy for stored image manifests that don't have any associated tags (untagged manifests). When a retention policy is enabled, untagged manifests in the registry are automatically deleted after a number of days you set."
  type        = number
  default     = null
}

################
### Security ###
################

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled."
  type        = bool
  default     = false
}

variable "anonymous_pull_enabled" {
  description = "Whether allows anonymous (unauthenticated) pull access to this Container Registry? This is only supported on resources with the Standard or Premium SKU."
  type        = bool
  default     = false
}

variable "quarantine_policy_enabled" {
  description = "Whether allows anonymous (unauthenticated) pull access to this Container Registry? This is only supported on resources with the Standard or Premium SKU."
  type        = bool
  default     = false
}

variable "trust_policy_enabled" {
  description = "Azure Container Registry implements Docker's content trust model, enabling pushing and pulling of signed images. If true, this feature is enabled."
  type        = bool
  default     = false
}

variable "cmk_encryption" {
  description = "Encrypt registry using a customer-managed key. The managed identity used in this variable must also be specified in var.user_assigned_managed_identity_ids."
  type = object({
    key_vault_key_id   = string
    identity_client_id = string
  })
  default = null
}

variable "user_assigned_managed_identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Registry."
  type        = list(string)
  default     = null
}
