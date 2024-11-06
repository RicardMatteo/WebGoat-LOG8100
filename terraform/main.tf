# Fournisseur Azure
provider "azurerm" {
  features {}
}

# Ressource de groupe de ressources Azure
resource "azurerm_resource_group" "k8s_rg" {
  name     = "example-k8s-rg"
  location = "East US"  # Remplacez par votre région préférée
}

# Cluster AKS
resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  name                = "example-k8s-cluster"
  location            = azurerm_resource_group.k8s_rg.location
  resource_group_name = azurerm_resource_group.k8s_rg.name
  dns_prefix          = "example-k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_b2ps_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Sortie pour obtenir l'information de connexion
output "kube_config" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.kube_config_raw
  sensitive = true
}

