terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "2.18.0"
    }
  }
}

provider "vault" {
  address = "https://vault:8210"
  # token   = VAULT_TOKEN environment variable
}
