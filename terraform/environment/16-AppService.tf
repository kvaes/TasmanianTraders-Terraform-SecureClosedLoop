resource "azurerm_resource_group" "frontend" {
  name     = "${var.prefix_environment}-${var.prefix_workload}-${var.webapp_identifier}"
  location = "${var.region_primary}"
}

resource "azurerm_app_service_plan" "frontend" {
  name                = "${var.prefix_workload}${var.prefix_environment}${var.webapp_identifier}"
  location            = "${azurerm_resource_group.frontend.location}"
  resource_group_name = "${azurerm_resource_group.frontend.name}"

  sku {
    tier = "${var.webapp_tier}"
    size = "${var.webapp_size}"
  }
}

resource "azurerm_app_service" "frontend" {
  name                = "${var.prefix_workload}${var.prefix_environment}${var.webapp_identifier}"
  location            = "${azurerm_resource_group.frontend.location}"
  resource_group_name = "${azurerm_resource_group.frontend.name}"
  app_service_plan_id = "${azurerm_app_service_plan.frontend.id}"

  app_settings {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.appinsights.instrumentation_key}"
  }
}

// resource "azurerm_app_service_slot" "frontend" {
//   name                = "staging"
//   app_service_name    = "${azurerm_app_service.frontend.name}"
//   location            = "${azurerm_resource_group.frontend.location}"
//   resource_group_name = "${azurerm_resource_group.frontend.name}"
//   app_service_plan_id = "${azurerm_app_service_plan.frontend.id}"
// }