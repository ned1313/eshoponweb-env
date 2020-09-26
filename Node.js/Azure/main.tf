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

variable "dbuser" {
  type = string
  default = "sqladmin"
}

variable "dbpassword" {
  type = string
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

data "http" "my_ip" {
    url = "http://ifconfig.me"
}

#### App Service

resource "azurerm_resource_group" "nightscout" {
  name     = "nightscout-${var.prefix}"
  location = var.location
}

resource "azurerm_app_service_plan" "nightscout" {
  name                = "nightscout-${var.prefix}"
  location            = azurerm_resource_group.nightscout.location
  resource_group_name = azurerm_resource_group.nightscout.name
  kind = "Linux"
  reserved = true

  sku {
    tier = var.asp_tier
    size = var.asp_size
    capacity = var.capacity
  }
}

resource "azurerm_app_service" "nightscout" {
  name                = "nightscout-${var.prefix}"
  location            = azurerm_resource_group.nightscout.location
  resource_group_name = azurerm_resource_group.nightscout.name
  app_service_plan_id = azurerm_app_service_plan.nightscout.id

  client_affinity_enabled = false
  

  site_config {
    linux_fx_version = "NODE|12-lts"
    always_on = true
  }

  app_settings {
    WEBSITE_NODE_DEFAULT_VERSION = "10.15.2"
    SCM_COMMAND_IDLE_TIMEOUT = "300"
  }

}


#### Azure CosmosDB

resource "azurerm_cosmosdb_account" "nightscout" {
  name                = "nightscout-${var.prefix}"
  location            = azurerm_resource_group.nightscout.location
  resource_group_name = azurerm_resource_group.nightscout.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  geo_location {
    prefix            = "nightscout-${var.prefix}-customid"
    location          = azurerm_resource_group.nightscout.location
    failover_priority = 0
  } 

  enable_automatic_failover = false

  capabilities {
    name = "DisableRateLimitingResponses"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

}

resource "azurerm_cosmosdb_mongo_database" "nightscout" {
  name                = "nightscout-${var.prefix}"
  resource_group_name = azurerm_resource_group.nightscout.name
  account_name        = azurerm_cosmosdb_account.nightscout.name
  throughput          = 400
}