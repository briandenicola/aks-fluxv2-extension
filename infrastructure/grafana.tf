resource "azurerm_dashboard_grafana" "this" {
  depends_on = [
    azapi_resource.azure_monitor_workspace
  ]

  name                              = "${local.resource_name}-grafana"
  resource_group_name               = azurerm_resource_group.this.name
  location                          = azurerm_resource_group.this.location
  sku                               = "Standard"
  zone_redundancy_enabled           = true
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true

  identity {
    type = "SystemAssigned"
  }

  azure_monitor_workspace_integrations {
    resource_id = local.am_workspace_id
  }
}