terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.56.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "LabCommon"
    storage_account_name = "common71977"
    container_name       = "terraform"
    key                  = "lab11ExtraTask.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "common_service_plan" {
  name                = "commonserviceplan"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  os_type             = "Windows"
  sku_name            = "B3"
}

resource "azurerm_app_service" "web_app" {
  name                = local.web_app_name
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  app_service_plan_id = azurerm_service_plan.common_service_plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
    always_on = true
  }
}