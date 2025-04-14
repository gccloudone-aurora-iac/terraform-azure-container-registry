# terraform-azurerm-container-registry

The module can be used to provision an Azure Container Registry.

## Usage

Examples for this module along with various configurations can be found in the [examples/](examples/) folder.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.15, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.15, < 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure_resource_names"></a> [azure\_resource\_names](#module\_azure\_resource\_names) | git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names.git | v2.0.0 |
| <a name="module_container_registry_name"></a> [container\_registry\_name](#module\_container\_registry\_name) | git::https://github.com/gccloudone-aurora-iac/terraform-aurora-azure-resource-names-global.git | v2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_resource_attributes"></a> [azure\_resource\_attributes](#input\_azure\_resource\_attributes) | Attributes used to describe Azure resources | <pre>object({<br>    project     = string<br>    environment = string<br>    location    = optional(string, "Canada Central")<br>    instance    = number<br>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which resources will be created | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU name of the container registry. Possible values are Basic, Standard and Premium. | `string` | n/a | yes |
| <a name="input_user_defined"></a> [user\_defined](#input\_user\_defined) | The user-defined segment that describes the purpose of the Key Vault name. | `string` | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Specifies whether the admin user is enabled. | `bool` | `false` | no |
| <a name="input_anonymous_pull_enabled"></a> [anonymous\_pull\_enabled](#input\_anonymous\_pull\_enabled) | Whether allows anonymous (unauthenticated) pull access to this Container Registry? This is only supported on resources with the Standard or Premium SKU. | `bool` | `false` | no |
| <a name="input_cmk_encryption"></a> [cmk\_encryption](#input\_cmk\_encryption) | Encrypt registry using a customer-managed key. The managed identity used in this variable must also be specified in var.user\_assigned\_managed\_identity\_ids. | <pre>object({<br>    key_vault_key_id   = string<br>    identity_client_id = string<br>  })</pre> | `null` | no |
| <a name="input_data_endpoint_enabled"></a> [data\_endpoint\_enabled](#input\_data\_endpoint\_enabled) | Whether to enable dedicated data endpoints for this Container Registry? This is only supported on resources with the Premium SKU. | `bool` | `false` | no |
| <a name="input_default_network_access_action"></a> [default\_network\_access\_action](#input\_default\_network\_access\_action) | The Default Action to use when no rules match from ip\_rules / virtual\_network\_subnet\_ids. Possible values are Allow and Deny. | `string` | `"Deny"` | no |
| <a name="input_export_policy_enabled"></a> [export\_policy\_enabled](#input\_export\_policy\_enabled) | To prevent registry users in an organization from maliciously or accidentally leaking artifacts outside a virtual network, you can configure the registry's export policy to disable exports. Set to false to prevent the export of artifacts from a network-restricted registry. In order to set it to false, make sure the public\_network\_access\_enabled is also set to false. | `bool` | `null` | no |
| <a name="input_georeplications"></a> [georeplications](#input\_georeplications) | Whether to geo-replicate the artifacts. The georeplications is only supported on new resources with the Premium SKU & the georeplications list cannot contain the location where the Container Registry exists. | <pre>list(object({<br>    location                  = string<br>    zone_redundancy_enabled   = optional(bool, false)<br>    regional_endpoint_enabled = optional(bool, false)<br>  }))</pre> | `[]` | no |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | One or more IP Addresses, or CIDR Blocks which should be able to access the Container Registry. | `set(string)` | `[]` | no |
| <a name="input_network_rule_bypass_option"></a> [network\_rule\_bypass\_option](#input\_network\_rule\_bypass\_option) | Whether to allow trusted Azure services to access a network restricted Container Registry? Possible values are None and AzureServices. | `string` | `"AzureServices"` | no |
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | The name of an existing subnet to deploy and allocate private IP addresses from a virtual network. It is used to create a private endpoint between the keyvault the module creates and the specified subnet. | <pre>list(object({<br>    sub_resource_name   = string<br>    subnet_id           = optional(string)<br>    private_dns_zone_id = string<br>  }))</pre> | `[]` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is allowed for this Container Registry. If false, only private endpoints can be created. | `bool` | `false` | no |
| <a name="input_quarantine_policy_enabled"></a> [quarantine\_policy\_enabled](#input\_quarantine\_policy\_enabled) | Whether allows anonymous (unauthenticated) pull access to this Container Registry? This is only supported on resources with the Standard or Premium SKU. | `bool` | `false` | no |
| <a name="input_retention_policy_days"></a> [retention\_policy\_days](#input\_retention\_policy\_days) | Set a retention policy for stored image manifests that don't have any associated tags (untagged manifests). When a retention policy is enabled, untagged manifests in the registry are automatically deleted after a number of days you set. | `number` | `null` | no |
| <a name="input_service_endpoint_subnet_ids"></a> [service\_endpoint\_subnet\_ids](#input\_service\_endpoint\_subnet\_ids) | The service endpoints to configure on the Container Registry. | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to set on the Azure Container Registry. | `map(string)` | `{}` | no |
| <a name="input_trust_policy_enabled"></a> [trust\_policy\_enabled](#input\_trust\_policy\_enabled) | Azure Container Registry implements Docker's content trust model, enabling pushing and pulling of signed images. If true, this feature is enabled. | `bool` | `false` | no |
| <a name="input_user_assigned_managed_identity_ids"></a> [user\_assigned\_managed\_identity\_ids](#input\_user\_assigned\_managed\_identity\_ids) | Specifies a list of User Assigned Managed Identity IDs to be assigned to this Container Registry. | `list(string)` | `null` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Whether zone redundancy is enabled for this replication location? | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The resource ID of the Container Registry. |
| <a name="output_identity"></a> [identity](#output\_identity) | The identity associated with the container registry. |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | The URL that can be used to log into the container registry. |
| <a name="output_private_endpoint_ids"></a> [private\_endpoint\_ids](#output\_private\_endpoint\_ids) | The Azure resource IDs of the private endpoints created. |
| <a name="output_private_endpoint_ip_config"></a> [private\_endpoint\_ip\_config](#output\_private\_endpoint\_ip\_config) | The IP configuration of the private endpoints. |
| <a name="output_user_assigned_managed_identity_ids"></a> [user\_assigned\_managed\_identity\_ids](#output\_user\_assigned\_managed\_identity\_ids) | n/a |
<!-- END_TF_DOCS -->

## History

| Date       | Release     | Change                                                                        |
| -----------| ------------| ------------------------------------------------------------------------------|
| 2025-01-25 | v1.0.0      | Initial commit                                                                |
