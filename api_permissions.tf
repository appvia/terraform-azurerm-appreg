locals {
  api_permissions_for_sp = {
    for api_permission in
    flatten(
      [
        for key, resources in var.azuread_api_permissions : [
          for resource_name, resource in resources.resource_access : {
            aad_app_key     = key
            resource_name   = resource_name
            resource_app_id = resources.resource_app_id
            id              = resource.id
            type            = resource.type
          } if resource.type == "Role"
        ]
      ]
    ) : format("%s-%s", api_permission.aad_app_key, api_permission.resource_name) => api_permission
  }

  api_permissions = local.api_permissions_for_sp
}

resource "time_sleep" "wait_for_directory_propagation" {
  depends_on = [azuread_service_principal.app]

  create_duration = "65s"
}

resource "null_resource" "grant_admin_consent" {
  depends_on = [time_sleep.wait_for_directory_propagation]

  for_each = {
    for key, permission in local.api_permissions : key => permission
  }

  provisioner "local-exec" {
    command     = format("%s/scripts/grant_consent.sh", path.module)
    interpreter = ["/bin/bash"]
    on_failure  = fail

    environment = {
      resourceAppId = each.value.resource_app_id
      appRoleId     = each.value.id
      principalId   = azuread_service_principal.app.id
      applicationId = azuread_application.app.client_id
    }
  }
}