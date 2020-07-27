############################
# VARIABLES
############################

variable "project_name" {}
variable "billing_account" {}
variable "org_id" {}
variable "region" {
    default = "us-central1"
}

variable "location_id" {}

variable "dbpassword" {
    type = string
}

############################
# PROVIDERS
############################

provider "google" {
  version = "~>2.0"
  region      = var.region
}

#############################################################################
# DATA SOURCES
#############################################################################

data "http" "my_ip" {
    url = "http://ifconfig.me"
}

############################
# RESOURCES
############################

resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  org_id          = var.org_id
}

resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com",
    "sqladmin.googleapis.com",
    "sql-component.googleapis.com",
    "appengine.googleapis.com",
    "appengineflex.googleapis.com",
    "cloudbuild.googleapis.com"

  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

resource "google_project_service" "service_beta" {
    provider = google-beta
    project            = google_project.project.project_id
  disable_on_destroy = false
  service = "compute.googleapis.com"
}

resource "google_app_engine_application" "app" {
  project     = google_project.project.project_id
  location_id = var.location_id
}

resource "google_sql_database" "database" {
  name     = "eShopOnWeb"
  instance = google_sql_database_instance.instance.name
  project = google_project.project.project_id
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta

  region = var.region
  database_version = "SQLSERVER_2017_STANDARD"
  project = google_project.project.project_id
  root_password = var.dbpassword

  settings {
    tier = "db-custom-4-16384"
    disk_size = 100

    ip_configuration {
        authorized_networks {
            value = "${data.http.my_ip.body}/32"
        }
    }
  }
}

############################
# OUTPUTS
############################

output "cloud_sql_instances" {
    value = google_sql_database_instance.instance.connection_name
}

output "project_id" {
    value = google_project.project.project_id
}

output "db_public_ip" {
    value = google_sql_database_instance.instance.public_ip_address
}