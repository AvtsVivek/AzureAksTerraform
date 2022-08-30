resource "azurerm_private_dns_zone" "example" {
  name                = "mydomain.com"
  resource_group_name = azurerm_resource_group.aks_rg.name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = "my-aks"
  location                = azurerm_resource_group.aks_rg.location
  resource_group_name     = azurerm_resource_group.aks_rg.name
  dns_prefix              = "myaks"
  private_cluster_enabled = true

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "my-aks-acr-123"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  public_network_access_enabled = false
  sku                 = "Premium"
  admin_enabled       = true
}

resource "azurerm_private_endpoint" "acr" {
  name                = "pvep-acr"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  # subnet_id           = YOUR_SUBNET

  # private_service_connection {
  #   name                           = "example-acr"
  #   # private_connection_resource_id = azurerm_container_registry.acr.id
  #   is_manual_connection           = false
  #   subresource_names              = ["registry"]
  # }

  # private_dns_zone_group {
  #   name                 = data.azurerm_private_dns_zone.example.name
  #   private_dns_zone_ids = [data.azurerm_private_dns_zone.example.id]
  # }
}

resource "azurerm_role_assignment" "acrpull" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  # scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}