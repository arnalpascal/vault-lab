resource "vault_pki_secret_backend_cert" "vault_cluster_node_2" {
  depends_on = [ vault_pki_secret_backend_role.pki_infra_role ]

  backend =  vault_mount.pki_infra.path
  name    = vault_pki_secret_backend_role.pki_infra_role.name

  common_name = "vault-cluster-node-2"

  alt_names = [ "vault" ]
}

output "vault_cluster_node_2_cert" {
  value = vault_pki_secret_backend_cert.vault_cluster_node_2.certificate
}

output "vault_cluster_node_2_private_key" {
  value = vault_pki_secret_backend_cert.vault_cluster_node_2.private_key
}