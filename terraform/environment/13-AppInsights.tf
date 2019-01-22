resource "azurerm_resource_group" "appinsights" {
  name     = "${var.prefix_environment}-${var.prefix_workload}-${var.appinsights_identifier}"
  location = "${var.region_primary}"
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.prefix_workload}${var.prefix_environment}"
  location            = "${azurerm_resource_group.appinsights.location}"
  resource_group_name = "${azurerm_resource_group.appinsights.name}"
  application_type    = "Web"
}