data "local_file" "function_hash" {
  filename = "function.zip.md5"
}


variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket, assumed to be already created"
  type        = string
  default =  hello-pubsub-function-bucket
}

variable "bucket_location" {
  description = "The location for the Google Cloud Storage bucket"
  default     = "us-central1"
}

resource "google_storage_bucket" "bucket" {
  name   = var.bucket_name
}


resource "google_storage_bucket_object" "function_code" {
  name   = "${var.function_name}-function-${trimspace(data.local_file.function_hash.content)}.zip"
  bucket = data.google_storage_bucket.bucket.name
  source = "function.zip"  # Ensure this file is generated in prior steps in your CI/CD pipeline
}



resource "google_pubsub_topic" "function_trigger_topic" {
  name = var.pubsub_topic
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
    resource   = google_pubsub_topic.function_trigger_topic.id
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
  value = google_pubsub_topic.function_trigger_topic.name
}
