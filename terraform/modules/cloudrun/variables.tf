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

variable "project_id" {
  type        = string
  description = "project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "service_name" {
  type        = string
  description = "CloudRun service name"
}

variable "bigquery_dataset" {
  type        = string
  description = "the bigquery dataset to push data"
}

variable "firestore_dataset" {
  type        = string
  description = "the firestore collection to use for token storage"
}

variable "source_dir" {
  type        = string
  description = "Source directory of the CloudRun service"
}

variable "repository_id" {
  type        = string
  description = "Repository ID in Artifact Registry"
}

variable "allow_unauthenticated" {
  type        = bool
  description = "Whether to allow unauthenticated access"

}

variable "web_app_domain" {
  type        = string
  description = "Web app domain, excluding protocol, if using domain mapping"
  default     = ""
}

variable "env_vars" {
  type = list(object({
    value = string
    name  = string
  }))
  description = "Environment variables (cleartext)"
  default     = []
}

