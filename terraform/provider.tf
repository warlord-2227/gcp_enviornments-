terraform {
  required_version = ">= 0.13"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.51.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "IWABC"

    workspaces {
      project = "merlin"
      name    = "gcp_enviornments-prod"
    }
  }
}
