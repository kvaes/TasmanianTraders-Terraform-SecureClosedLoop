resource "azurerm_resource_group" "functions" {
  name     = "${var.prefix_environment}-${var.prefix_workload}-${var.functions_identifier}"
  location = "${var.region_primary}"
}

resource "azurerm_app_service_plan" "functions" {
  name                = "${var.prefix_workload}${var.prefix_environment}${var.functions_identifier}"
  location            = "${azurerm_resource_group.functions.location}"
  resource_group_name = "${azurerm_resource_group.functions.name}"
  kind                = "FunctionApp"

  sku {
    tier = "${var.functions_tier}"
    size = "${var.functions_size}"
  }
}

resource "azurerm_function_app" "functionsread" {
  name                      = "${var.prefix_workload}${var.prefix_environment}${var.functions_identifier}read"
  location                  = "${azurerm_resource_group.functions.location}"
  resource_group_name       = "${azurerm_resource_group.functions.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.functions.id}"
  storage_connection_string = "${azurerm_storage_account.storage.primary_connection_string}"
  version                   = "~2"
  https_only                = "true"

  app_settings {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.appinsights.instrumentation_key}"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_function_app" "functionswrite" {
  name                      = "${var.prefix_workload}${var.prefix_environment}${var.functions_identifier}write"
  location                  = "${azurerm_resource_group.functions.location}"
  resource_group_name       = "${azurerm_resource_group.functions.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.functions.id}"
  storage_connection_string = "${azurerm_storage_account.storage.primary_connection_string}"
  version                   = "~2"
  https_only                = "true"

  app_settings {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.appinsights.instrumentation_key}"
  }

  identity {
    type = "SystemAssigned"
  }
}