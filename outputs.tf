output "resource_group_name" {
  value = azurerm_resource_group.aks-tf-tut-rg.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks-kubernetes-cluster.name
}
output "acr_login_server" {
  value = azurerm_container_registry.aks-container-registry.login_server
}

output "acr_username" {
  value = azurerm_container_registry.aks-container-registry.admin_username
}

output "acr_password" {
  value     = azurerm_container_registry.aks-container-registry.admin_password
  sensitive = true
}

