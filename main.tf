resource "azurerm_resource_group" "aks-tf-tut-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "aks-container-registry" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks-tf-tut-rg.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks-kubernetes-cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-tf-tut-rg.name
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name            = "defaultpool"
    node_count      = var.system_node_count
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true
}

resource "azurerm_role_assignment" "container_registry_role-assignment" {
  principal_id         = var.principalid
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.aks-container-registry.id
}