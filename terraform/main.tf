data "local_file" "function_hash" {
  filename = "function.zip.md5"
}

data "google_storage_bucket" "bucket" {
  name = var.bucket_name
}

data "google_pubsub_topic" "topic" {
  name = var.pubsub_topic
}

resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true  // Be very cautious with this setting
}

resource "google_storage_bucket_object" "function_code" {
  name   = "${var.function_name}-function-${trimspace(data.local_file.function_hash.content)}.zip"
  bucket = data.google_storage_bucket.bucket.name
  source = "function.zip"  // Ensure this path is correct
}


resource "google_pubsub_topic" "function_trigger_topic" {
  count = var.manage_pubsub_topic ? 1 : 0
  name  = var.pubsub_topic
}

resource "google_cloudfunctions_function" "default" {
  name                  = var.function_name
  description           = "A Cloud Function triggered by Pub/Sub"
  runtime               = var.runtime
  available_memory_mb   = 256
  source_archive_bucket = data.google_storage_bucket.bucket.name
  source_archive_object = "function.zip"  // Adjust as necessary
  entry_point           = var.entry_point

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = var.manage_pubsub_topic ? google_pubsub_topic.function_trigger_topic[0].id : ""
  }

  environment_variables = {
    LAST_UPDATE_TIME = timestamp()
  }
  project = var.project_id
  region  = var.region

  labels = {
    "content-hash" = trimspace(data.local_file.function_hash.content)
  }

  lifecycle {
    create_before_destroy = true
  }
}
