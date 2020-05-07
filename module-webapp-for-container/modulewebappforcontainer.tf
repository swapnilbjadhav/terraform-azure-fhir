# Use the Azure Resource Manager Provider
provider "azurerm"{
    subscription_id=var.azure_subscription_id
    client_id=var.azure_client_id
    client_secret=var.azure_client_secret
    tenant_id=var.azure_tenant_id  
version = "=2.0.0"
features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

# Create a new Resource Group
resource "azurerm_resource_group" "group" {
  name     = var.resource_group
  location = var.location
}

# Create an App Service Plan with Linux
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "${azurerm_resource_group.group.name}-plan"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  # Define Windows ux as Host OS
  kind                = "Linux"
  



  # Choose size
  sku {
    tier = "Standard"
    size = "S1"
  }
  reserved  = true
  tags ={	
                owner="SwapnilJadhav"	
            }
}

# Create an Azure Web App for Containers in that App Service Plan
resource "azurerm_app_service" "dockerapp" {
  name                = "${azurerm_resource_group.group.name}-dockerapp"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id



  # Do not attach Storage by default
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = "https://index.docker.io"
    DOCKER_REGISTRY_SERVER_USERNAME = ""
    DOCKER_REGISTRY_SERVER_PASSWORD = ""
    
  }

 
  # Configure Docker Image to load on start
  site_config {
    linux_fx_version = "DOCKER|nginx"
    always_on        = true
    use_32_bit_worker_process = true
    default_documents = [
                    "Default.htm",	
                    "Default.html",	
                    "Default.asp",	
                    "index.htm",	
                    "index.html",	
                    "iisstart.htm",	
                    "default.aspx",	
                    "index.php",	
                    "hostingstart.html"]
  } 

  
  client_affinity_enabled = false

}