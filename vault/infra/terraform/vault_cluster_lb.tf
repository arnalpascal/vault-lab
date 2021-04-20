resource "vault_pki_secret_backend_cert" "vault_cluster_lb" {
  depends_on = [ vault_pki_secret_backend_role.pki_infra_role ]

  backend = vault_mount.pki_infra.path
  name    = vault_pki_secret_backend_role.pki_infra_role.name

  common_name = "vault-cluster-lb"

  alt_names = [ "vault" ]
}

output "vault_cluster_lb_cert" {
  value = vault_pki_secret_backend_cert.vault_cluster_lb.certificate
}

output "vault_cluster_lb_private_key" {
  value = vault_pki_secret_backend_cert.vault_cluster_lb.private_key
}