resource "azurerm_resource_group" "storage" {
  name     = "${var.prefix_environment}-${var.prefix_workload}-${var.storage_identifier}"
  location = "${var.region_primary}"
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.prefix_workload}${var.prefix_environment}"
  resource_group_name      = "${azurerm_resource_group.storage.name}"
  location                 = "${azurerm_resource_group.storage.location}"
  account_tier             = "${var.storage_tier}"
  account_replication_type = "${var.storage_resiliency}"

  // provisioner "local-exec" {
  //   command = "az login  --service-principal -u \"${var.armclientid}\" -p \"${var.armclientsecret}\" --tenant \"${var.armtenantid}\" | az storage blob service-properties update --account-name ${azurerm_storage_account.storage.name} --static-website  --index-document index.html --404-document 404.html"
  // }
}
