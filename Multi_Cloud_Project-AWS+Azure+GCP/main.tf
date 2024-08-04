provider "aws" {
  region                   = "us-west-2"
  shared_credentials_files = ["C:/Users/Rishav/.aws/credentials"]
  profile                  = "Administrator"
}

provider "google" {
  project = "fit-mantra-338807"
  region  = "us-central1"
  zone    = "us-central1-c"
}

provider "azurerm" {
  features {}
}