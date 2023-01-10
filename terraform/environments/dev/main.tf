/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


# project-specific locals
locals {
  services = [
    "appengine.googleapis.com",            # AppEngine
    "artifactregistry.googleapis.com",     # Artifact Registry
    "bigquery.googleapis.com",             # BigQuery
    "bigquerydatatransfer.googleapis.com", # BigQuery Data Transfer
    "cloudbuild.googleapis.com",           # Cloud Build
    "compute.googleapis.com",              # Load Balancers, Cloud Armor
    "container.googleapis.com",            # Google Kubernetes Engine
    "containerregistry.googleapis.com",    # Google Container Registry
    "dataflow.googleapis.com",             # Cloud Dataflow
    "firebase.googleapis.com",             # Firebase
    "firestore.googleapis.com",            # Firestore
    "iam.googleapis.com",                  # Cloud IAM
    "logging.googleapis.com",              # Cloud Logging
    "monitoring.googleapis.com",           # Cloud Operations Suite
    "run.googleapis.com",                  # Cloud Run
    "secretmanager.googleapis.com",        # Secret Manager
    "storage.googleapis.com",              # Cloud Storage
    "cloudscheduler.googleapis.com",       # Cloud Scheduler
  ]
}

data "google_project" "project" {}

module "project_services" {
  source     = "../../modules/project_services"
  project_id = var.project_id
  services   = local.services
}

module "service_accounts" {
  depends_on     = [module.project_services]
  source         = "../../modules/service_accounts"
  project_id     = var.project_id
  env            = var.env
  project_number = data.google_project.project.number
}

module "firebase" {
  depends_on       = [module.project_services]
  source           = "../../modules/firebase"
  project_id       = var.project_id
  firestore_region = var.firestore_region
  firebase_init    = var.firebase_init
}


# Deploy sample-service to CloudRun
# Uncomment below to enable deploying microservices with CloudRun.
module "enrollment_webapp" {
  depends_on = [module.project_services]

  source                = "../../modules/cloudrun"
  project_id            = var.project_id
  region                = var.region
  source_dir            = "../../.."
  service_name          = "deviceconnect"
  repository_id         = "cloudrun"
  allow_unauthenticated = true
  web_app_domain        = var.web_app_domain
  bigquery_dataset      = var.bigquery_dataset
  firestore_dataset     = var.firestore_dataset
  env_vars = [
    { name = "FITBIT_OAUTH_CLIENT_ID", value = var.fitbit_oauth_client_id },
    { name = "FITBIT_OAUTH_CLIENT_SECRET", value = var.fitbit_oauth_client_secret },
    { name = "OPENID_AUTH_METADATA_URL", value = var.openid_auth_metadata_url },
    { name = "OPENID_AUTH_CLIENT_ID", value = var.openid_auth_client_id },
    { name = "OPENID_AUTH_CLIENT_SECRET", value = var.openid_auth_client_secret }
  ]
}

module "bigquery" {
  depends_on = [module.project_services]

  source           = "../../modules/bigquery"
  project_id       = var.project_id
  region           = var.region
  bigquery_dataset = var.bigquery_dataset
}

module "cloudscheduler" {
  depends_on = [module.enrollment_webapp]

  source          = "../../modules/cloudscheduler"
  project_id      = var.project_id
  region          = var.region
  webapp_base_url = module.enrollment_webapp.ingest
}

