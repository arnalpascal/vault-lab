terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "2.18.0"
    }
  }
}

# provider "vault" {
#   alias   = "infra"
#   address = "http://localhost:8200"
#   token   = "secrettoken"
# }

provider "vault" {
  #alias   = "cluster"
  address = "https://vault:8210"
  # token   = VAULT_TOKEN environment variable
}
