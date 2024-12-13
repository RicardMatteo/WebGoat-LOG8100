provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "aks" {
  name     = "webgoat-rg"
  location = "Canada Central"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-cluster-LOG8100"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "aks-cluster-LOG8100"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "standard_b2ps_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
