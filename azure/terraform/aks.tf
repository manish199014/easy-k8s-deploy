resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = data.external.environment.result["location"]
  resource_group_name = data.external.environment.result["resource_group_name"]
  dns_prefix          = "${var.cluster_name}-${random_string.dns.result}"

  sku_tier = "Free"

  role_based_access_control_enabled = true
  local_account_disabled            = false

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "sysnp"
    vm_size    = var.vm_size
    node_count = var.node_count
    os_sku     = "Ubuntu"

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }
}
