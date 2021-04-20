resource "vault_pki_secret_backend_cert" "vault_transit" {
  depends_on = [ vault_pki_secret_backend_role.pki_infra_role ]

  backend = vault_mount.pki_infra.path
  name    = vault_pki_secret_backend_role.pki_infra_role.name

  common_name = "vault-transit"

  alt_names = [ "vault" ]
}

output "vault_transit_cert" {
  value = vault_pki_secret_backend_cert.vault_transit.certificate
}

output "vault_transit_private_key" {
  value = vault_pki_secret_backend_cert.vault_transit.private_key
}