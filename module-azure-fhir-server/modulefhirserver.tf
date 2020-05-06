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

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

# create a resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group
  location = var.location

  tags = {
        environment = var.tags_environment
        team = var.tags_team
    }
}

# create a key vault
resource "azurerm_key_vault" "example" {
  name                        = "fhirservertestvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]

    storage_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }

  tags = {
    environment = "Testing"
  }
}


# create a app service plan
resource "azurerm_app_service_plan" "example" {
  name                = "api-appserviceplan-pro"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}


#create a app service website
resource "azurerm_app_service" "example" {
  name                = "fhir-server-example-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2017"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}


#create a azure app insights
resource "azurerm_application_insights" "example" {
  name                = "tf-test-appinsights"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

output "instrumentation_key" {
  value = azurerm_application_insights.example.instrumentation_key
}

output "app_id" {
  value = azurerm_application_insights.example.app_id
}

###################################################################################################
###################################################################################################

# create a app service plan  
resource "azurerm_app_service_plan" "example-test" {
  name                = "testservicename-asp"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Standard"
    size = "S1"
  }
  tags = {
    environment = "Testing"
  }
}

#create a app service website
resource "azurerm_app_service" "example-test" {
  name                = "testservicename-app-service"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example-test.id

  site_config {
    dotnet_framework_version = "v4.0"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2017"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  identity  {
    type  = "SystemAssigned"
  }

  tags = {
    environment = "Testing"
  }
}

#create a azure app insights
resource "azurerm_application_insights" "example-test" {
  name                = "testservicename-test-appinsights"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

output "instrumentation_key_testing" {
  value = azurerm_application_insights.example-test.instrumentation_key
}

output "app_id_testing" {
  value = azurerm_application_insights.example-test.app_id
}


########################################################################################################
########################################################################################################

#create a app service sql server and sql database
resource "azurerm_sql_server" "example" {
  name                         = "fhirserver-mysqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = "West US"
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

  tags = {
    environment = "production"
  }
}

resource "azurerm_sql_database" "example" {
  name                = "fhirserver-mysqldatabase"
  resource_group_name = azurerm_resource_group.example.name
  location            = "West US"
  server_name         = azurerm_sql_server.example.name

  tags = {
    environment = "production"
  }
}


##################################################################################################
##################################################################################################

variable "md_content" {
  description = "Content for the MD tile"
  default     = "# Hello all :)"
}

variable "video_link" {
  description = "Link to a video"
  default     = "https://www.youtube.com/watch?v=......"
}

resource "azurerm_dashboard" "my-board" {
  name                = "my-cool-dashboard"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  tags = {
    source = "terraform"
  }
  dashboard_properties = <<DASH
{
   "lenses": {
        "0": {
            "order": 0,
            "parts": {
                "0": {
                    "position": {
                        "x": 0,
                        "y": 0,
                        "rowSpan": 2,
                        "colSpan": 3
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/HubsExtension/PartType/MarkdownPart",
                        "settings": {
                            "content": {
                                "settings": {
                                    "content": "${var.md_content}",
                                    "subtitle": "",
                                    "title": ""
                                }
                            }
                        }
                    }
                },               
                "1": {
                    "position": {
                        "x": 5,
                        "y": 0,
                        "rowSpan": 4,
                        "colSpan": 6
                    },
                    "metadata": {
                        "inputs": [],
                        "type": "Extension/HubsExtension/PartType/VideoPart",
                        "settings": {
                            "content": {
                                "settings": {
                                    "title": "Important Information",
                                    "subtitle": "",
                                    "src": "${var.video_link}",
                                    "autoplay": true
                                }
                            }
                        }
                    }
                },
                "2": {
                    "position": {
                        "x": 0,
                        "y": 4,
                        "rowSpan": 4,
                        "colSpan": 6
                    },
                    "metadata": {
                        "inputs": [
                            {
                                "name": "ComponentId",
                                "value": "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/myRG/providers/microsoft.insights/components/myWebApp"
                            }
                        ],
                        "type": "Extension/AppInsightsExtension/PartType/AppMapGalPt",
                        "settings": {},
                        "asset": {
                            "idInputName": "ComponentId",
                            "type": "ApplicationInsights"
                        }
                    }
                }              
            }
        }
    },
    "metadata": {
        "model": {
            "timeRange": {
                "value": {
                    "relative": {
                        "duration": 24,
                        "timeUnit": 1
                    }
                },
                "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
            },
            "filterLocale": {
                "value": "en-us"
            },
            "filters": {
                "value": {
                    "MsPortalFx_TimeRange": {
                        "model": {
                            "format": "utc",
                            "granularity": "auto",
                            "relative": "24h"
                        },
                        "displayCache": {
                            "name": "UTC Time",
                            "value": "Past 24 hours"
                        },
                        "filteredPartIds": [
                            "StartboardPart-UnboundPart-ae44fef5-76b8-46b0-86f0-2b3f47bad1c7"
                        ]
                    }
                }
            }
        }
    }
}
DASH
}




