ui            = true
disable_mlock = true

cluster_name = "vault-lab-cluster"

listener "tcp" {
  address         = "[::]:8200"
  cluster_address = "[::]:8201"
  tls_cert_file = "/cluster/node/pki/vault_cluster.crt"
  tls_key_file  = "/cluster/node/pki/vault_cluster.key"
}

seal "transit" {
  address            = "https://vault:8200"
  disable_renewal    = "false"

  // Key configuration
  key_name           = "vault-lab"
  mount_path         = "transit"

  // TLS Configuration
  tls_ca_cert        = "/cluster/node/pki/ca.crt"
  tls_skip_verify    = "false"
}

storage "raft" {
  path = "/cluster/node/vault-data"

  retry_join {
    leader_api_addr = "https://vault:8210"
    leader_ca_cert_file = "/cluster/node/pki/ca.crt"
  }
  retry_join {
    leader_api_addr = "https://vault:8220"
    leader_ca_cert_file = "/cluster/node/pki/ca.crt"
  }
  retry_join {
    leader_api_addr = "https://vault:8230"
    leader_ca_cert_file = "/cluster/node/pki/ca.crt"
  }
}