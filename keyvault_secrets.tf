resource "azurerm_key_vault_secret" "client_id" {
  #checkov:skip=CKV_AZURE_41:This secret is not sensitive and does not expire.  It is for context only.
  for_each = { for k, v in var.keyvault_ids : k => v }

  name         = format("%s-client-id", var.name)
  value        = azuread_application.app.client_id
  content_type = "text/plain"
  key_vault_id = each.value
  tags         = var.tags
}

resource "azurerm_key_vault_secret" "client_secret" {
  for_each        = { for k, v in var.keyvault_ids : k => v }
  name            = format("%s-client-secret", var.name)
  value           = azuread_service_principal_password.pwd.value
  content_type    = "password"
  key_vault_id    = each.value
  expiration_date = timeadd(time_rotating.pwd.id, format("%sh", var.password_policy.expire_in_days * 24))
  tags            = var.tags
}

resource "azurerm_key_vault_secret" "tenant_id" {
  #checkov:skip=CKV_AZURE_41:This secret is not sensitive and does not expire.  It is for context only.
  for_each     = { for k, v in var.keyvault_ids : k => v }
  name         = format("%s-tenant-id", var.name)
  value        = var.tenant_id
  content_type = "text/plain"
  key_vault_id = each.value
  tags         = var.tags
}