############################
# VARIABLES
############################

variable "prefix" {
    type = string
    description = "Prefix for resources"
}

variable "location" {
    type = string
    description = "Azure region"
    default = "East US"
}

variable "asp_tier" {
    type = string
    description = "Tier for App Service Plan (Standard, PremiumV2)"
}

variable "asp_size" {
    type = string
    description = "Size for App Service Plan (S2, P1v2)"
}

variable "capacity" {
  type = string
  description = "Number of instances for App Service Plan"
}

############################
# PROVIDERS
############################

provider "azurerm" {
  version = "~>2.0"
  features {}
}

############################
# RESOURCES
############################

#### App Service

resource "azurerm_resource_group" "eshopweb" {
  name     = "eShopOnWeb-${var.prefix}"
  location = var.location
}

resource "azurerm_app_service_plan" "eshopweb" {
  name                = "eShopOnWeb-${var.prefix}"
  location            = azurerm_resource_group.eshopweb.location
  resource_group_name = azurerm_resource_group.eshopweb.name

  sku {
    tier = var.asp_tier
    size = var.asp_size
    capacity = var.capacity
  }
}

resource "azurerm_app_service" "example" {
  name                = "eShopOnWeb-${var.prefix}"
  location            = azurerm_resource_group.eshopweb.location
  resource_group_name = azurerm_resource_group.eshopweb.name
  app_service_plan_id = azurerm_app_service_plan.eshopweb.id

  client_affinity_enabled = false
  

  site_config {
    dotnet_framework_version = "v4.0"
    always_on = true
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "6.9.1"
  }

  connection_string {
    name  = "CatalogConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldb.name};User Id=gigadmin@${azurerm_mssql_server.sqlserver.name};Password=Jun!p3rtree13"
  }

    connection_string {
    name  = "IdentityConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sqldb.name};User Id=gigadmin@${azurerm_mssql_server.sqlserver.name};Password=Jun!p3rtree13"
  }
}


#### Azure SQL

resource "azurerm_mssql_server" "sqlserver" {
  name                         = "eshoponweb${lower(var.prefix)}"
  resource_group_name          = azurerm_resource_group.eshopweb.name
  location                     = azurerm_resource_group.eshopweb.location
  version                      = "12.0"
  administrator_login          = "gigadmin"
  administrator_login_password = "Jun!p3rtree13"

}

resource "azurerm_mssql_database" "sqldb" {
  name                = "eShopOnWeb${var.prefix}"
  server_id        = azurerm_mssql_server.sqlserver.id

  max_size_gb    = 50
  sku_name = "GP_Gen5_2"

}