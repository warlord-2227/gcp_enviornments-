resource "google_storage_bucket" "function_bucket" {
  name     = "${var.function_name}-bucket"
  location = var.region
}

resource "google_storage_bucket_object" "function_code" {
  name   = var.source_archive_filename
  bucket = google_storage_bucket.function_bucket.name
  source = "path/to/${var.source_archive_filename}"
}

resource "google_pubsub_topic" "function_trigger_topic" {
  name = var.pubsub_topic
}

resource "google_cloudfunctions_function" "default" {
  name                  = var.function_name
  description           = "A Cloud Function triggered by Pub/Sub"
  runtime               = var.runtime
  available_memory_mb   = 256
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.function_code.name
  entry_point           = var.entry_point

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.function_trigger_topic.id
  }

  environment_variables = {
    EXAMPLE_VAR = "example_value"
  }
}

output "function_url" {
  value = google_cloudfunctions_function.default.https_trigger_url
}

output "pubsub_topic" {
  value = google_pubsub_topic.function_trigger_topic.name
}
