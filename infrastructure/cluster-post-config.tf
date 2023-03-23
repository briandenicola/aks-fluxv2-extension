data "azapi_resource" "weekend_utc" {
  type = "Microsoft.Maintenance/publicMaintenanceConfigurations@2021-09-01-preview"
  name = "aks-mrp-cfg-weekend_utc-6"
  parent_id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
}

resource "azapi_resource" "maintenance_window" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type = "Microsoft.Maintenance/configurationAssignments@2022-07-01-preview"
  name = "maintenance-window"
  location = local.location
  parent_id = azurerm_kubernetes_cluster.this.id
  body = jsonencode({
    properties = {
      maintenanceConfigurationId = data.azapi_resource.weekend_utc.id
      resourceId =  azurerm_kubernetes_cluster.this.id 
    }
  })
}

resource "azapi_update_resource" "this" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type        = "Microsoft.ContainerService/managedClusters@2023-02-02-preview"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      autoUpgradeProfile = {
        nodeOSUpgradeChannel = "NodeImage"
      }
    }
  })
}