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


resource "google_artifact_registry_repository" "cloudrun_repository" {
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for CloudRun"
  format        = "DOCKER"
}

resource "google_cloud_run_service_iam_member" "allusers-enrollment" {
  project  = var.project_id
  location = var.region
  service  = "${var.service_name}-enrollment"
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [time_sleep.wait_for_enrollment_service]
}

resource "google_cloud_run_service_iam_member" "allusers-ingest" {
  count    = (var.allow_unauthenticated ? 1 : 0)
  project  = var.project_id
  location = var.region
  service  = "${var.service_name}-ingestion"
  role     = "roles/run.invoker"
  member   = "allUsers"

  depends_on = [time_sleep.wait_for_ingest_service]
}

resource "time_sleep" "wait_for_enrollment_service" {
  create_duration = "30s"

  depends_on = [google_cloud_run_service.webapp]
}

resource "time_sleep" "wait_for_ingest_service" {
  create_duration = "30s"

  depends_on = [google_cloud_run_service.ingest]
}


# Creating a custom service account for cloud run
module "cloud-run-service-account" {
  source       = "github.com/terraform-google-modules/cloud-foundation-fabric/modules/iam-service-account/"
  project_id   = var.project_id
  name         = "cloudrun-sa"
  display_name = "This is service account for cloud run"

  iam = {
    "roles/iam.serviceAccountUser" = []
  }

  iam_project_roles = {
    (var.project_id) = [
      "roles/eventarc.eventReceiver",
      "roles/firebase.admin",
      "roles/firestore.serviceAgent",
      "roles/iam.serviceAccountUser",
      "roles/iam.serviceAccountTokenCreator",
      "roles/run.invoker",
      "roles/pubsub.serviceAgent",
      "roles/bigquery.dataEditor",
      "roles/bigquery.user"
    ]
  }
}


resource "null_resource" "deploy-cloudrun-image" {

  provisioner "local-exec" {
    working_dir = var.source_dir
    command = join(" ", [
      "gcloud builds submit",
      "--config=cloudbuild.yaml",
      join("", [
        "--substitutions=",
        join(",", [
          "_PROJECT_ID='${var.project_id}'",
          "_IMAGE='${var.service_name}'",
          "_REGION='${var.region}'",
          "_REPOSITORY=${var.repository_id}"
        ])
      ])
    ])
  }
}

#
# Deploy end-user enrollment webapp
#
resource "google_cloud_run_service" "webapp" {
  # provider = google
  project  = var.project_id
  name     = "${var.service_name}-enrollment"
  location = var.region
  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.service_name}"
        resources {
          limits = {
            "memory" = "1G"
            "cpu"    = "1"
          }
        }
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.value["name"]
            value = env.value["value"]
          }
        }
        env {
          name  = "FRONTEND_ONLY"
          value = true
        }
        env {
          name = "BIGQUERY_DATASET"
          value = var.bigquery_dataset
        }
        env {
          name = "FIRESTORE_DATASET"
          value = var.firestore_dataset
        }
      }
      service_account_name = module.cloud-run-service-account.email
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "1"
      }
      labels = {
        goog-packaged-solution = "device-connect-for-fitbit"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  depends_on = [null_resource.deploy-cloudrun-image]
}

data "google_project" "project" {}

resource "google_cloud_run_domain_mapping" "webapp" {
  count = "${var.web_app_domain != "" ? 1 : 0}"

  name     = var.web_app_domain
  location = google_cloud_run_service.webapp.location
  metadata {
    namespace = data.google_project.project.project_id
  }
  spec {
    route_name = google_cloud_run_service.webapp.name
  }
}


# Deploy ingestion webapp to Cloud Run
resource "google_cloud_run_service" "ingest" {
  # provider = google
  project  = var.project_id
  name     = "${var.service_name}-ingestion"
  location = var.region
  template {
    spec {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}/${var.service_name}"
        resources {
          limits = {
            "memory" = "1G"
            "cpu"    = "1"
          }
        }
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.value["name"]
            value = env.value["value"]
          }
        }
        env {
          name  = "BACKEND_ONLY"
          value = true
        }
        env {
          name = "BIGQUERY_DATASET"
          value = var.bigquery_dataset
        }
        env {
          name = "FIRESTORE_DATASET"
          value = var.firestore_dataset
        }
      }
      service_account_name = module.cloud-run-service-account.email
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "1"
      }
      labels = {
        goog-packaged-solution = "device-connect-for-fitbit"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  depends_on = [null_resource.deploy-cloudrun-image]
}