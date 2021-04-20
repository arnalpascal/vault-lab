resource "vault_mount" "pki_infra" {
  path                      = "pki-infra"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 31536000
}

resource "vault_pki_secret_backend_root_cert" "pki_infra" {
  depends_on = [ vault_mount.pki_infra ]

  backend = vault_mount.pki_infra.path

  type                 = "internal"
  common_name          = "Vault lab infra CA"
  ttl                  = "315360000"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
}

resource "vault_pki_secret_backend_config_urls" "pki_infra_config_urls" {
  backend                 = vault_mount.pki_infra.path

  issuing_certificates    = ["http://127.0.0.1:8200/v1/pki-infra/ca"]
  crl_distribution_points = ["http://127.0.0.1:8200/v1/pki-infra/crl"]
}

resource "vault_pki_secret_backend_role" "pki_infra_role" {
  backend = vault_mount.pki_infra.path

  name    = "pki-infra-role"

  allow_localhost  = true
  allow_any_name   = true
  allow_ip_sans    = true
  allow_subdomains = true

  max_ttl = "8760h"
}

output "pki_infra_ca" {
  value = vault_pki_secret_backend_root_cert.pki_infra.certificate
}