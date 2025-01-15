resource "azuread_application" "app" {
  display_name            = var.name
  prevent_duplicate_names = true
  sign_in_audience        = "AzureADMyOrg"

  feature_tags {
    enterprise = true
    gallery    = true
  }

  dynamic "required_resource_access" {
    for_each = var.azuread_api_permissions

    content {
      resource_app_id = required_resource_access.value.resource_app_id

      dynamic "resource_access" {
        for_each = {
          for key, resource in required_resource_access.value.resource_access : key => resource
        }

        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }
}

resource "azuread_service_principal" "app" {
  client_id                    = azuread_application.app.client_id
  app_role_assignment_required = var.app_role_assignment_required
  tags = [
    "WindowsAzureActiveDirectoryGalleryApplicationNonPrimaryV1",
    "WindowsAzureActiveDirectoryIntegratedApp"
  ]
}

resource "azuread_service_principal_password" "pwd" {
  service_principal_id = azuread_service_principal.app.id
  end_date             = timeadd(time_rotating.pwd.id, format("%sh", var.password_policy.expire_in_days * 24))
  rotate_when_changed = {
    rotation = time_rotating.pwd.id
  }

  lifecycle {
    create_before_destroy = false
  }
}

resource "time_rotating" "pwd" {
  rotation_minutes = try(var.password_policy.rotation.mins, null)
  rotation_days    = try(var.password_policy.rotation.days, null)
  rotation_months  = try(var.password_policy.rotation.months, null)
  rotation_years   = try(var.password_policy.rotation.years, null)
}

resource "azuread_directory_role" "role" {
  for_each     = var.directory_roles
  display_name = each.value
}

resource "azuread_directory_role_assignment" "role_assignment" {
  for_each            = var.directory_roles
  role_id             = azuread_directory_role.role[each.key].template_id
  principal_object_id = azuread_service_principal.app.object_id
}