provider "azurerm"{
    subscription_id=var.azure_subscription_id
    client_id=var.azure_client_id
    client_secret=var.azure_client_secret
    tenant_id=var.azure_tenant_id  
version = "=2.0.0"
features{}
}

# create a resource group
resource "azurerm_resource_group" "azure_terraform_resource_group"  {
  name     = var.resource_group
  location = var.location

}

resource "azurerm_container_registry" "acr" {
  name                     = "containerRegistryCT"
  resource_group_name      = azurerm_resource_group.azure_terraform_resource_group.name
  location                 = azurerm_resource_group.azure_terraform_resource_group.location
  sku                      = "Standard"
  admin_enabled            = false
}