terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "2.18.0"
    }
  }
}

provider "vault" {
}