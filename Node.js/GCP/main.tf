############################
# VARIABLES
############################

variable "billing_account" {}
variable "org_id" {}
variable "region" {
    default = "us-central1"
}

variable "location_id" {}

variable "mongodbatlas_public_key" {}
variable "mongodbatlas_private_key" {}
variable "mongodbatlas_org_id" {}
variable "mongodbatlas_database_password" {
  default = "dakjf87683rbjdvs98djh"
}

############################
# PROVIDERS
############################

provider "google" {
  version = "~>2.0"
  region      = var.region
}

provider "mongodbatlas" {
  public_key = var.mongodbatlas_public_key
  private_key = var.mongodbatlas_private_key
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

resource "mongodbatlas_project" "run" {
  name   = terraform.workspace
  org_id = var.mongodbatlas_org_id
}

resource "mongodbatlas_cluster" "run" {
  project_id   = mongodbatlas_project.run.id
  name         = terraform.workspace
  cluster_type = "REPLICASET"

  provider_backup_enabled      = false
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.2"

  //Provider Settings "block"
  provider_name               = "GCP"
  disk_size_gb                = 40
  provider_instance_size_name = "M30"
  provider_region_name        = "CENTRAL_US"
}

resource "mongodbatlas_project_ip_whitelist" "run" {
  project_id = mongodbatlas_project.run.id
  cidr_block = "0.0.0.0/0"
  comment    = "Allow all"
}

resource "mongodbatlas_database_user" "run" {
  username           = "Employer"
  password = var.mongodbatlas_database_password
  project_id         = mongodbatlas_project.run.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }

}

resource "random_id" "id" {
  byte_length = 4
  prefix      = terraform.workspace
}

resource "google_project" "project" {
  name            = terraform.workspace
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  org_id          = var.org_id
}

resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com",
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



############################
# OUTPUTS
############################

output "project_id" {
    value = google_project.project.project_id
}

output "plstring" {
    value = mongodbatlas_cluster.run.connection_strings[0].standard
}