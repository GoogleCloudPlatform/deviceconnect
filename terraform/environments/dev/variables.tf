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

variable "feature_flags" {
  type        = string
  description = "A comma-seperated string of feature flags to enable specific terraform blocks."
  default     = "gke,gke-ingress"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "project_id" {
  type        = string
  description = "GCP Project ID"

  validation {
    condition     = length(var.project_id) > 0
    error_message = "The project_id value must be an non-empty string."
  }
}

variable "region" {
  type        = string
  description = "Default GCP region"
  default     = "us-central1"

  validation {
    condition     = length(var.region) > 0
    error_message = "The region value must be an non-empty string."
  }
}

variable "firestore_region" {
  type        = string
  description = "Firestore Region"
  default     = "us-central"
}

variable "bq_dataset_location" {
  type        = string
  description = "BigQuery Dataset location"
  default     = "US"
}

variable "storage_multiregion" {
  type    = string
  default = "us"
}

variable "admin_email" {
  type = string
}

variable "web_app_domain" {
  type        = string
  description = "Web app domain, excluding protocol, if using domain mapping"
  default     = ""
}

variable "firebase_init" {
  type        = bool
  description = "Whether to initialize Firebase/Firestore."
  default     = true
}

variable "fitbit_oauth_client_id" {
  type        = string
  description = "fitbit webapi developer client id"
}

variable "fitbit_oauth_client_secret" {
  type        = string
  description = "fitbit webapi developer client secret"
}

variable "openid_auth_metadata_url" {
  type        = string
  description = "see documentation"
}

variable "openid_auth_client_id" {
  type        = string
  description = "see documentation"
}

variable "openid_auth_client_secret" {
  type        = string
  description = "see documentation"
}

variable "bigquery_dataset" {
  type        = string
  description = "the name of the bigquery dataset to use"
  default     = "fitbit"
}

variable "firestore_dataset" {
  type        = string
  description = "firestore collection name to use"
  default     = "tokens"
}
