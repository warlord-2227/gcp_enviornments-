terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }

  cloud {
    organization = "IWABC"
    workspaces {
      project = "merlin"
      name    = "gcp_enviornments-production"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "google" {
  project     = "my-project-6242-308916"
  credentials = var.google_credentials
  region      = "us-central1"
  scopes      = ["https://www.googleapis.com/auth/compute", "https://www.googleapis.com/auth/cloud-platform","https://www.googleapis.com/auth/cloudfunctions"]
}
