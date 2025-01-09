output "azuread_application" {
  value = {
    id             = azuread_application.app.id
    object_id      = azuread_application.app.object_id
    application_id = azuread_application.app.client_id
    name           = azuread_application.app.display_name
    client_id      = azuread_application.app.client_id
    client_secret  = azuread_service_principal_password.pwd.value
  }
  description = "Outputs the IDs of application"
  sensitive   = true
}

output "azuread_service_principal" {
  value = {
    id        = azuread_service_principal.app.id
    object_id = azuread_service_principal.app.object_id
  }
  description = "Outputs the identifiers of the Azure AD Service Principal"
}

output "rbac_id" {
  value       = azuread_service_principal.app.object_id
  description = "This attribute is used to set the role assignment"
}