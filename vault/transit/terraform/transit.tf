resource "vault_mount" "transit" {
  path                      = "transit"
  type                      = "transit"
}

resource "vault_transit_secret_backend_key" "key" {
  backend = vault_mount.transit.path
  name    = "vault-lab"
}

resource "vault_policy" "autounseal" {
  name = "autounseal"

  policy = <<EOT
path "transit/encrypt/vault-lab" {
   capabilities = [ "create", "update" ]
}

path "transit/decrypt/vault-lab" {
   capabilities = [ "create", "update" ]
}
EOT
}


