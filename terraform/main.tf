data "local_file" "function_hash" {
  filename = "function.zip.md5"
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket, assumed to be already created"
  type        = string
  default     = "hello-pubsub-function-bucket"
}

variable "bucket_location" {
  description = "The location for the Google Cloud Storage bucket"
  default     = "us-central1"
}

# Data source to reference an existing bucket
data "google_storage_bucket" "bucket" {
  name = var.bucket_name
}

variable "manage_pubsub_topic" {
  description = "Flag to manage the Pub/Sub topic with Terraform"
  type        = bool
  default     = true
}


# Using a condition to create or not create the Pub/Sub topic
resource "google_pubsub_topic" "function_trigger_topic" {
  count = var.manage_pubsub_topic ? 1 : 0
  name  = var.pubsub_topic
}

resource "google_storage_bucket_object" "function_code" {
  name   = "${var.function_name}-function-${trimspace(data.local_file.function_hash.content)}.zip"
  bucket = data.google_storage_bucket.bucket.name
  source = "function.zip"
}

resource "google_cloudfunctions_function" "default" {
  name                  = var.function_name
  description           = "A Cloud Function triggered by Pub/Sub"
  runtime               = var.runtime
  available_memory_mb   = 256
  source_archive_bucket = data.google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.function_code.name
  entry_point           = var.entry_point

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = var.manage_pubsub_topic ? google_pubsub_topic.function_trigger_topic[0].id : ""
  }

  environment_variables = {
    LAST_UPDATE_TIME = timestamp()
  }
  project = var.project_id
  region  = var.bucket_location

  labels = {
    "content-hash" = trimspace(data.local_file.function_hash.content)
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "pubsub_topic" {
  value = var.manage_pubsub_topic ? google_pubsub_topic.function_trigger_topic[0].name : "Topic management is disabled"
}
