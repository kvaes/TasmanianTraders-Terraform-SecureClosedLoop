resource "azurerm_key_vault" "keyvaultsensitive" {
  name                        = "${var.prefix_workload}${var.prefix_environment}sensitive"
  location                    = "${azurerm_resource_group.keyvault.location}"
  resource_group_name         = "${azurerm_resource_group.keyvault.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.armtenantid}"

  sku {
    name = "${var.keyvault_sku}"
  }

}

resource "azurerm_key_vault_access_policy" "keyvaultsensitivepolicysp" {
  vault_name          = "${azurerm_key_vault.keyvaultsensitive.name}"
  resource_group_name = "${azurerm_key_vault.keyvaultsensitive.resource_group_name}"

  tenant_id = "${var.armtenantid}"
  object_id = "${var.armobjectid}"

  secret_permissions = [
    "get", 
    "set", 
    "list",
  ]

  depends_on = ["azurerm_key_vault.keyvault"]
}

resource "azurerm_key_vault_secret" "mssqluser" {
  name      = "mssqladminuser"
  value     = "${random_string.mssqluser.result}"
  vault_uri = "${azurerm_key_vault.keyvaultsensitive.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.keyvaultsensitivepolicysp"]
}

resource "azurerm_key_vault_secret" "mssqlpassword" {
  name      = "mssqladminpass"
  value     = "${random_string.mssqlpassword.result}"
  vault_uri = "${azurerm_key_vault.keyvaultsensitive.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.keyvaultsensitivepolicysp"]
}

resource "azurerm_key_vault_secret" "mssqlhost" {
  name      = "mssqlhost"
  value     = "${azurerm_sql_server.mssql.fully_qualified_domain_name}"
  vault_uri = "${azurerm_key_vault.keyvaultsensitive.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.keyvaultsensitivepolicysp"]
}

resource "azurerm_key_vault_secret" "mssqldb" {
  name      = "mssqldb"
  value     = "${azurerm_sql_database.mssql.name}"
  vault_uri = "${azurerm_key_vault.keyvaultsensitive.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.keyvaultsensitivepolicysp"]
}