resource "vault_mount" "pki_root" {
  path                      = "pki-root"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

resource "vault_pki_secret_backend_root_cert" "pki_root" {
  depends_on = [ vault_mount.pki_root ]

  backend = vault_mount.pki_root.path

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
  backend                 = vault_mount.pki_root.path

  issuing_certificates    = ["https://vault:8443/v1/pki-root/ca"]
  crl_distribution_points = ["https://vault:8443/v1/pki-root/crl"]
}
