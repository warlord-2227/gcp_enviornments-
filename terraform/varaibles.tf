variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
  default     = "my-project-6242-308916"
}

variable "google_credentials" {
  type        = string
  sensitive   = true
  default     = ""
  description = "Google Cloud service account credentials"
}

variable "region" {
  description = "The region where the function and resources will be deployed"
  type        = string
  default     = "us-central1"
}

variable "function_name" {
  description = "Name of the Cloud Function"
  type        = string
  default     = "hello-pubsub-function-test"
}

variable "source_archive_filename" {
  description = "Filename for the zipped source archive"
  type        = string
  default     = "hello-pubsub.zip"
}

variable "pubsub_topic" {
  description = "Name of the Pub/Sub topic to be created and used as a trigger"
  type        = string
  default     = "hello-pubsub-topic-test"
}

variable "runtime" {
  description = "Runtime environment for the Cloud Function"
  type        = string
  default     = "python39"
}

variable "entry_point" {
  description = "Entry point of the Cloud Function"
  type        = string
  default     = "hello_pubsub"
}
