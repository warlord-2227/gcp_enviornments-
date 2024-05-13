variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
  default     = "my-project-6242-308916"
}

variable "region" {
  description = "The region where the function and resources will be deployed"
  type        = string
  default     = "us-central1"
}

variable "function_name" {
  description = "Name of the Cloud Function"
  type        = string
  default     = "hello-pubsub-function-prod"
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket, assumed to be already created"
  type        = string
  default     = "mast_bucket_test"
}

variable "pubsub_topic" {
  description = "Name of the Pub/Sub topic, assumed to be already created"
  type        = string
  default     = "mast_pubsub"
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

variable "google_credentials" {
  description = "Google Cloud service account credentials JSON"
  type        = string
  default     = ""  // You can keep this empty if you're passing the value via command line or environment variable
  sensitive   = true  // This marks the variable as sensitive, which prevents Terraform from showing its value in logs
}


variable "manage_pubsub_topic" {
  description = "Flag to manage the Pub/Sub topic with Terraform"
  type        = bool
  default     = true
}
