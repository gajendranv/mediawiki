terraform {
  backend "azurerm" {
    resource_group_name = "rg-dev-ns-aks-001"
    storage_account_name = "stfsdevnsaks001"
    container_name       = "tfstate"
    key                  = "yNfp1Yapva11Pp9m2g/rOq6rVoh33lT3Oa2TS13qfLIVPOvnyn/rnhlwPVNWp0dfTjdaEsDUXXuC+AStCkzfXQ=="
  }
}

//resource "azurerm_storage_account" "tfstatemediawiki"{
  // name = "tfstatedrupaltest"
   //resource_group_name = azurerm_resource_group.aks_rg.name
   //location            = azurerm_resource_group.aks_rg.location
//}

data "azurerm_key_vault" "azure_vault" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_rg
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = var.sshkvsecret
  key_vault_id = data.azurerm_key_vault.azure_vault.id
}

data "azurerm_key_vault_secret" "spn_id" {
  name         = var.clientidkvsecret
  key_vault_id = data.azurerm_key_vault.azure_vault.id
}
data "azurerm_key_vault_secret" "spn_secret" {
  name         = var.spnkvsecret
  key_vault_id = data.azurerm_key_vault.azure_vault.id
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  address_space       = var.vnetcidr
} 

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks_subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes       = var.subnetcidr
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group
  location = var.azure_region
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  location            = var.azure_region
  resource_group_name = var.resource_group
  
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.dns_name


  default_node_pool {
    name            = var.agent_pools.name
    node_count      = var.agent_pools.count
    vm_size         = var.agent_pools.vm_size
    os_disk_size_gb = var.agent_pools.os_disk_size_gb
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = data.azurerm_key_vault_secret.ssh_public_key.value
    }
  }

  role_based_access_control_enabled = true

  service_principal {
    client_id     = data.azurerm_key_vault_secret.spn_id.value
    client_secret = data.azurerm_key_vault_secret.spn_secret.value
  }

  tags = {
    Environment = "devenv"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  scope = azurerm_container_registry.acr.id

  role_definition_name = "Acrdpull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}

#test code for namespace 

// resource "null_resource" "AKSdetails" {
//     depends_on = [ azurerm_kubernetes_cluster.aks_cluster ]
//     provisioner "local-exec" {
//         command = "terraform output -raw kube_config > ~/.kube/config && az aks get-credentials --name ${var.cluster_name} --resource-group ${azurerm_resource_group.aks_rg.name} --overwrite-existing --file ~/.kube/config}"
//     }
// }



provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "aksnamespaces" {
  depends_on = [ azurerm_kubernetes_cluster.aks_cluster ]
  for_each = toset(var.namespaces)
  metadata {
    name = "${each.key}"
  }
}

resource "kubernetes_deployment" "mediawikideployment" {
  depends_on = [kubernetes_namespace.aksnamespaces]
  for_each = toset(var.namespaces)
  metadata {
    name      = "${each.key}-mediawiki"
    namespace = "${each.key}"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "${each.key}-mediawiki"
      }
    }
    template {
      metadata {
        labels = {
          app = "${each.key}-mediawiki"
        }
      }
      spec {
        container {
          image = "acrns001.azurecr.io/mediawiki-1.0:latest"
          name  = "mediawiki-container"
          port {
            container_port = 80
          }
          
        }
          
        }
      }
    }
  }

resource "kubernetes_service" "mediawiki-svc" {
  depends_on = [kubernetes_namespace.aksnamespaces]
  for_each = toset(var.namespaces)
  metadata {
    name      = "${each.key}-mediawiki"
    namespace = "${each.key}"
  }
  spec {
    selector = {
      app = "${each.key}-mediawiki"
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_deployment" "mariadb_deployment" {
  depends_on = [kubernetes_namespace.aksnamespaces]
  for_each = toset(var.namespaces)
  metadata {
    name      = "${each.key}-mariadb"
    namespace = "${each.key}"

    
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "${each.key}-mariadb"
      }
    }
    template {
      metadata {
        labels = {
          app = "${each.key}-mariadb" 
        }
      }
      spec {
        container {
          name  = "mariadb"
          image = "acrns001.azurecr.io/mariadb:1.0:latest"
          env {
            name  = "MYSQL_ROOT_PASSWORD"
            value = "MyNewPass4!"
          }
          port {
            container_port = 3306
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mariadb_service" {
  depends_on = [kubernetes_namespace.aksnamespaces]
  for_each = toset(var.namespaces)
  metadata {
    name ="${each.key}-mariadb"
  }
  spec {
    selector = {
      app = "${each.key}-mariadb"
    }
    port {
      port        = 3306
      target_port = 3306
    }
    type = "LoadBalancer"
  }
}