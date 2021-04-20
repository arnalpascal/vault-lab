resource "vault_token" "vault_cluster_node_1_unseal_token" {
  display_name = "vault_token_unseal_n1"

  policies = [ vault_policy.autounseal.name ]

  period    = 604800
  no_parent = true
  renewable = true
}

output "vault_cluster_node_1_unseal_token" {
  value = vault_token.vault_cluster_node_1_unseal_token.client_token
}
