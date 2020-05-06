provider "azurerm"{
    subscription_id=var.azure_subscription_id
    client_id=var.azure_client_id
    client_secret=var.azure_client_secret
    tenant_id=var.azure_tenant_id  
version = "=2.0.0"
features{}
}

# create a resource group
resource "azurerm_resource_group" "azure_terraform_resource_group" {
  name     = var.resource_group
  location = var.location

  tags = {
        environment = var.tags_environment
        team = var.tags_team
    }
}

# create a azure api for fhir resource
resource "azurerm_healthcare_service" "fhir_api_settings" {
  name                = var.azurerm_healthcare_service_name
  resource_group_name = azurerm_resource_group.azure_terraform_resource_group.name
  location            = azurerm_resource_group.azure_terraform_resource_group.location
  kind                = var.azurerm_healthcare_service_kind
  cosmosdb_throughput = "2000"
  access_policy_object_ids = [var.azurerm_healthcare_service_access_policy_object_id]
  tags = {
    environment = var.tags_environment
    team = var.tags_team
  }

  authentication_configuration {
    authority           = "https://login.microsoftonline.com/${var.azure_tenant_id}"
    audience            = "https://${var.azurerm_healthcare_service_name}.azurehealthcareapis.com"
    smart_proxy_enabled = var.azurerm_healthcare_service_smart_proxy_enabled
  }

  cors_configuration {
    allowed_headers    = var.allow_headers    
    allowed_methods    = var.allow_methods
    allowed_origins    = var.allow_origin
    max_age_in_seconds = var.allow_max_age
    allow_credentials  = var.allow_credentials
  }
}
