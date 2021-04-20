ui            = true
disable_mlock = true

listener "tcp" {
  address = "[::]:8200"
  tls_cert_file = "/transit/pki/vault_transit.crt"
  tls_key_file  = "/transit/pki/vault_transit.key"
}

storage "file" {
  path = "/transit/vault-data"
}