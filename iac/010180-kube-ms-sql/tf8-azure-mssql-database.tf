

resource "azurerm_mssql_server" "mssql_server" {
  name                         = "${local.resource_name_prefix}-${var.mssql_server_name}"
  resource_group_name          = azurerm_resource_group.aks_rg.name
  location                     = azurerm_resource_group.aks_rg.location
  version                      = "12.0"
  administrator_login          = var.db_username
  administrator_login_password = var.db_password
}

resource "azurerm_mssql_database" "mssql_database" {
  name           = "${local.resource_name_prefix}-${var.mssql_database_name}"
  server_id      = azurerm_mssql_server.mssql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = local.common_tags
}

resource "azurerm_mssql_firewall_rule" "allow_azure_access" {
  name             = "Allow_access_to_Azure_services"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}