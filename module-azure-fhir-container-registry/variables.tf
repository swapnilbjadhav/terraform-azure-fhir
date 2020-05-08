##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

# var.azure_subscription_id
variable "azure_subscription_id" {
    type=string
    default="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# var.azure_client_id
variable "azure_client_id" {
    type=string
    default="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# var.azure_client_secret
variable "azure_client_secret" {
    type=string
    default="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# var.azure_tenant_id
variable "azure_tenant_id" {
    type=string
    default="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# var.resource_group
variable "resource_group" {
  description = "The name of your Azure Resource Group."
  default     = "FHIR-Azure-Container-Registry"
}

# var.location
variable "location" {
  description = "The region where the virtual network is created."
  default     = "eastus2"
}

# var.tags_environment
variable "tags_environment" {
  default     = "Terraform with Azure API For FHIR Getting Started"
}

# var.tags_team
variable "tags_team" {
  default     = "Development"
}

# var.azurerm_healthcare_service_name
variable "azurerm_healthcare_service_name" {
    type=string
    default="swapnil-fhir-resources"
}

# var.azurerm_healthcare_service_kind
variable "azurerm_healthcare_service_kind" {
    type=string
    default="fhir-R4"
}

# var.azurerm_healthcare_service_access_policy_object_id
variable "azurerm_healthcare_service_access_policy_object_id" {
    type=string
    default="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

# var.azurerm_healthcare_service_smart_proxy_enabled
variable "azurerm_healthcare_service_smart_proxy_enabled" {
    type=string
    default="true"
}

# -----------------------------------------------------------------------------
# Variables: CORS-related
# -----------------------------------------------------------------------------

# var.allow_headers
variable "allow_headers" {
  description = "Allow headers"
  type        = list(string)
  default = ["*"]
}

# var.allow_methods
variable "allow_methods" {
  description = "Allow methods"
  type        = list(string)
  default = [
    "OPTIONS",
    "GET",
    "POST",
    "PUT",
    "DELETE",
  ]
}

# var.allow_origin
variable "allow_origin" {
  description = "Allow origin"
  type        = list(string)
  default = ["*"]
}

# var.allow_max_age
variable "allow_max_age" {
  description = "Allow response caching time"
  type        = string
  default     = "400"
}

# var.allow_credentials
variable "allow_credentials" {
  description = "Allow credentials"
  default     = false
}