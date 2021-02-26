terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "2.18.0"
    }
  }
}

provider "vault" {
  address = "http://localhost:8200"
  token   = "secrettoken"
}