resource "vault_pki_secret_backend" "pki_root" {
  path                      = "pki-root"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_pki_secret_backend_root_cert" "pki_root" {
  depends_on = [ vault_pki_secret_backend.pki_root ]

  backend = vault_pki_secret_backend.pki_root.path

  type                 = "internal"
  common_name          = "Vault lab Root CA"
  ttl                  = "315360000"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
}

resource "vault_pki_secret_backend_config_urls" "pki_root_config_urls" {
  backend                 = vault_pki_secret_backend.pki_root.path

  issuing_certificates    = ["http://127.0.0.1:8200/v1/pki-root/ca"]
  crl_distribution_points = ["http://127.0.0.1:8200/v1/pki-root/crl"]
}
