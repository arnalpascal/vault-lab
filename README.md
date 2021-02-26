# vault-lab

Start a Vault lab with podman on fedora.
Go to /vagrant and start vault with
```
podman play kube vault-cluster.yml
```

Set Vault environment variables :
```
export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=secrettoken
```

Next go to /vagrant/terraform and initialize PKI
```
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Use Vault to generate private keys and certficates
```
vault write -format=json pki-int/issue/pki-int-role common_name=test.org sans=other.org ip_sans=10.0.0.1
```