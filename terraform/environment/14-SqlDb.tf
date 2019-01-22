resource "azurerm_resource_group" "mssql" {
  name     = "${var.prefix_environment}-${var.prefix_workload}-${var.mssql_identifier}"
  location = "${var.region_primary}"
}

resource "random_string" "mssqluser" {
  length = 16
  special = false
  number = false
}

resource "random_string" "mssqlpassword" {
  length = 32
  special = true
  override_special = "/@\" "
}

resource "azurerm_sql_server" "mssql" {
  name                         = "${var.prefix_workload}${var.prefix_environment}sqlsrv"
  resource_group_name          = "${azurerm_resource_group.mssql.name}"
  location                     = "${azurerm_resource_group.mssql.location}"
  version                      = "12.0"
  administrator_login          = "${random_string.mssqluser.result}"
  administrator_login_password = "${random_string.mssqlpassword.result}"
}

resource "azurerm_sql_database" "mssql" {
  name                             = "${var.prefix_workload}${var.prefix_environment}sqldb"
  resource_group_name              = "${azurerm_resource_group.mssql.name}"
  location                         = "${azurerm_resource_group.mssql.location}"
  server_name                      = "${azurerm_sql_server.mssql.name}"
  requested_service_objective_name = "${var.mssql_size}"
}

resource "azurerm_sql_active_directory_administrator" "mssql" {
  server_name         = "${azurerm_sql_server.mssql.name}"
  resource_group_name = "${azurerm_resource_group.mssql.name}"
  login               = "sqladmin"
  tenant_id           = "${var.armtenantid}"
  object_id           = "${var.armobjectid}"
}