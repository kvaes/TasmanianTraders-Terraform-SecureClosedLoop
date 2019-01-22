variable "armsubscriptionid" {}
variable "armclientid" {}
variable "armclientsecret" {}
variable "armtenantid" {}

provider "azurerm" {
  version = "=1.20.0"
  subscription_id = "${var.armsubscriptionid}"
  client_id       = "${var.armclientid}"
  client_secret   = "${var.armclientsecret}"
  tenant_id       = "${var.armtenantid}"
}