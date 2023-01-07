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





resource "google_cloud_scheduler_job" "fitbit_activity_pull" {
  project          = var.project_id
  region           = var.region

  name             = "fitbit_activity_pull"
  description      = "Pull Fitbit Body Weight Scope"
  schedule         = "30 13 * * *"
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "${var.webapp_base_url}/fitbit_activity_scope"
  }
}

resource "google_cloud_scheduler_job" "fitbit_body_weight_pull" {
  project          = var.project_id
  region           = var.region

  name             = "fitbit_body_weight_pull"
  description      = "Pull Fitbit Body Weight Scope"
  schedule         = "35 13 * * *"
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "${var.webapp_base_url}/fitbit_body_weight"
  }
}

resource "google_cloud_scheduler_job" "fitbit_data_pull" {
  project          = var.project_id
  region           = var.region

  name             = "fitbit_data_pull"
  description      = "Pull user Fitbit data"
  schedule         = "40 13 * * *"
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "${var.webapp_base_url}/fitbit_chunk_1"
  }
}

resource "google_cloud_scheduler_job" "fitbit_heart_rate_pull" {
  project          = var.project_id
  region           = var.region

  name             = "fitbit_heart_rate_pull"
  description      = "Pull Fitbit heart rate Scope"
  schedule         = "45 13 * * *"
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "${var.webapp_base_url}/fitbit_heart_rate_scope"
  }
}


resource "google_cloud_scheduler_job" "fitbit_intraday_pull" {
  project          = var.project_id
  region           = var.region

  name             = "fitbit_intraday_pull"
  description      = "Pull Fitbit Intraday Data"
  schedule         = "50 13 * * *"
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "${var.webapp_base_url}/fitbit_intraday_scope"
  }
}


resource "google_cloud_scheduler_job" "fitbit_nutrition_pull" {
  project          = var.project_id
  region           = var.region

  name             = "fitbit_nutrition_pull"
  description      = "Pull Fitbit Nutrition Scope"
  schedule         = "55 13 * * *"
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "${var.webapp_base_url}/fitbit_nutrition_scope"
  }
}

resource "google_cloud_scheduler_job" "fitbit_sleep_pull" {
  project          = var.project_id
  region           = var.region

  name             = "fitbit_sleep_pull"
  description      = "Pull Fitbit Sleep Pull"
  schedule         = "00 14 * * *"
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "${var.webapp_base_url}/fitbit_sleep_scope"
  }
}


