variable "app_role_assignment_required" {
  type        = bool
  description = "Set to true to indicate that the application requires app role assignment."
  default     = true
}

variable "directory_roles" {
  type        = set(string)
  description = "Set of AzureAD directory role names to be assigned to the service principal."
  default     = []
}

variable "keyvault_ids" {
  type        = list(string)
  description = "List of keyvault ids to store the secrets."
  default     = []
}

variable "name" {
  type        = string
  description = "Name of the application."
}

variable "password_policy" {
  description = "Default password policy applies when not set in tfvars."
  type = object({
    expire_in_days = number
    rotation = object({
      mins   = optional(number)
      days   = optional(number)
      months = optional(number, 1)
      years  = optional(number)
    })
  })
  default = {
    # Define the number of days the password is valid. It must be more than the rotation frequency
    expire_in_days = 180
    rotation = {
      months = 1
    }
  }
}

variable "tags" {
  type        = map(string)
  description = "Set tags to apply to the resources"
  default     = {}
}

variable "tenant_id" {
  type        = string
  description = "Tenant id of the application."
}