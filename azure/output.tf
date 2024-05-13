output "client_certificate" {
  value = "${azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate}"
}

output "kube_config" {
  value = "${azurerm_kubernetes_cluster.aks_cluster.kube_config_raw}"
  sensitive = true
}

// output "storage_account_primary_access_key" {
//   value = data.azurerm_storage_account.tfstatedrupal.primary_access_key
// }