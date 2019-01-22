variable "armobjectid" {}

resource "azurerm_resource_group" "keyvault" {
  name     = "${var.prefix_environment}-${var.prefix_workload}-${var.keyvault_identifier}"
  location = "${var.region_primary}"
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.prefix_workload}${var.prefix_environment}"
  location                    = "${azurerm_resource_group.keyvault.location}"
  resource_group_name         = "${azurerm_resource_group.keyvault.name}"
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.armtenantid}"

  sku {
    name = "${var.keyvault_sku}"
  }

}

resource "azurerm_key_vault_access_policy" "keyvaultpolicysp" {
  vault_name          = "${azurerm_key_vault.keyvault.name}"
  resource_group_name = "${azurerm_key_vault.keyvault.resource_group_name}"

  tenant_id = "${var.armtenantid}"
  object_id = "${var.armobjectid}"

  secret_permissions = [
    "get", 
    "set", 
    "list",
  ]

  depends_on = ["azurerm_key_vault.keyvault"]
}

resource "azurerm_key_vault_access_policy" "keyvaultpolicymsifunctionsread" {
  vault_name          = "${azurerm_key_vault.keyvault.name}"
  resource_group_name = "${azurerm_key_vault.keyvault.resource_group_name}"

  tenant_id = "${azurerm_function_app.functionsread.identity.0.tenant_id}"
  object_id = "${azurerm_function_app.functionsread.identity.0.principal_id}"

  secret_permissions = [
    "get", 
    "list",
  ]

  depends_on = ["azurerm_function_app.functionsread"]
}

resource "azurerm_key_vault_access_policy" "keyvaultpolicymsifunctionswrite" {
  vault_name          = "${azurerm_key_vault.keyvault.name}"
  resource_group_name = "${azurerm_key_vault.keyvault.resource_group_name}"

  tenant_id = "${azurerm_function_app.functionswrite.identity.0.tenant_id}"
  object_id = "${azurerm_function_app.functionswrite.identity.0.principal_id}"

  secret_permissions = [
    "set", 
    "list",
  ]

  depends_on = ["azurerm_function_app.functionswrite"]
}

resource "azurerm_key_vault_secret" "keyvaultsecretsapk" {
  name      = "storageaccountprimarykey"
  value     = "${azurerm_storage_account.storage.primary_access_key}"
  vault_uri = "${azurerm_key_vault.keyvault.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.keyvaultpolicysp"]
}

resource "azurerm_key_vault_secret" "keyvaultsecretfrontendrgname" {
  name      = "frontendrgname"
  value     = "${azurerm_app_service.frontend.resource_group_name}"
  vault_uri = "${azurerm_key_vault.keyvault.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.keyvaultpolicysp"]
}

resource "azurerm_key_vault_secret" "keyvaultsecretfrontendappname" {
  name      = "frontendwebappname"
  value     = "${azurerm_app_service.frontend.name}"
  vault_uri = "${azurerm_key_vault.keyvault.vault_uri}"
  depends_on = ["azurerm_key_vault_access_policy.keyvaultpolicysp"]
}