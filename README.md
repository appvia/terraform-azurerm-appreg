
# Terraform Azure Landing Zone Application Registration Module

## Description

This repository deploys the Azure App Registrations and associated service principals for Landing Zones deployment.

## Usage
This module provides the following functionality:

1. Creates an Azure AD Application.
2. Configures Service Principal and its password.
3. Manages API permissions for the application using required_resource_access.
4. Handles password rotation using time_rotating resources.
5. Assigns Directory Roles to the Service Principal.


## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
2. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | >= 2.33.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.43.0 |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.9.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the application. | `string` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Tenant id of the application. | `string` | n/a | yes |
| <a name="input_app_role_assignment_required"></a> [app\_role\_assignment\_required](#input\_app\_role\_assignment\_required) | Set to true to indicate that the application requires app role assignment. | `bool` | `true` | no |
| <a name="input_azuread_api_permissions"></a> [azuread\_api\_permissions](#input\_azuread\_api\_permissions) | List of Azure AD API permissions to grant to the application. | <pre>map(object({<br/>    resource_app_id = string,<br/>    resource_access = map(object({<br/>      id   = string,<br/>      type = string<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_directory_roles"></a> [directory\_roles](#input\_directory\_roles) | Set of AzureAD directory role names to be assigned to the service principal. | `set(string)` | `[]` | no |
| <a name="input_keyvault_ids"></a> [keyvault\_ids](#input\_keyvault\_ids) | List of keyvault ids to store the secrets. | `list(string)` | `[]` | no |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | Default password policy applies when not set in tfvars. | <pre>object({<br/>    expire_in_days = number<br/>    rotation = object({<br/>      mins   = optional(number)<br/>      days   = optional(number)<br/>      months = optional(number, 1)<br/>      years  = optional(number)<br/>    })<br/>  })</pre> | <pre>{<br/>  "expire_in_days": 180,<br/>  "rotation": {<br/>    "months": 1<br/>  }<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Set tags to apply to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azuread_application"></a> [azuread\_application](#output\_azuread\_application) | Outputs the IDs of application |
| <a name="output_azuread_service_principal"></a> [azuread\_service\_principal](#output\_azuread\_service\_principal) | Outputs the identifiers of the Azure AD Service Principal |
| <a name="output_rbac_id"></a> [rbac\_id](#output\_rbac\_id) | This attribute is used to set the role assignment |
<!-- END_TF_DOCS -->