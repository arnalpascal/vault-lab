resource "vault_mount" "pki_int" {
  path                      = "pki-int"
  type                      = "pki"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 43800
}

resource "vault_pki_secret_backend_intermediate_cert_request" "pki_int" {
  depends_on = [ vault_mount.pki_int ]

  backend = vault_mount.pki_int.path

  type        = "internal"
  common_name = "vault-lab.test"
  
  format             = "pem"
  private_key_format = "der"
  key_type           = "rsa"
  key_bits           = 4096

}

resource "vault_pki_secret_backend_root_sign_intermediate" "root_pki_int" {
  depends_on = [ vault_pki_secret_backend_intermediate_cert_request.pki_int ]

  backend = vault_mount.pki_root.path

  csr                  = vault_pki_secret_backend_intermediate_cert_request.pki_int.csr
  common_name          = "Vault lab Intermediate CA"
  exclude_cn_from_sans = true

  format = "pem_bundle"

  ttl = "43800"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "pki_root_pki_int" { 
  backend = vault_mount.pki_int.path

  certificate = "${vault_pki_secret_backend_root_sign_intermediate.root_pki_int.certificate}\n${vault_pki_secret_backend_root_cert.pki_root.certificate}"
}

resource "vault_pki_secret_backend_config_urls" "pki_int_config_urls" {
  backend = vault_mount.pki_int.path

  issuing_certificates    = ["https://vault:8443/v1/pki-int/ca"]
  crl_distribution_points = ["https://vault:8443/v1/pki-int/crl"]
}

resource "vault_pki_secret_backend_role" "pki_int_role" {
  backend = vault_mount.pki_int.path

  name    = "pki-int-role"

  allow_localhost  = true
  allow_any_name   = true
  allow_ip_sans    = true
  allow_subdomains = true

  max_ttl = "72h"
}