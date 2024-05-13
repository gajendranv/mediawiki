aks_vnet_name = "aksvnet"

sshkvsecret = "akspubsshkey"

clientidkvsecret = "spn-id"

spnkvsecret = "spn-secret"

vnetcidr = ["10.0.0.0/24"]

subnetcidr = ["10.0.0.0/25"]

keyvault_rg = "rg-mediawiki"

keyvault_name = "test001000"

azure_region = "CentralIndia"

resource_group = "aksdemocluster-rg"

cluster_name = "aksdemocluster"

dns_name = "aksdemocluster"

admin_username = "aksuser"

acr_name = "acrns001"

kubernetes_version = "1.26"

agent_pools = {
      name            = "pool1"
      count           = 1
      vm_size         = "Standard_D2_v2"
      os_disk_size_gb = "30"
    }

namespaces=["devenv"]
