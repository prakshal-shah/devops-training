provider "azurerm" {
  features {} 
}

resource "azurerm_resource_group" "resources" {
  location = var.location
  name     = var.resource_grp_name
}

module "network" {
  source = "./network"
  location = var.location
  resource_grp_name = azurerm_resource_group.resources.name
}

module "vm" {
  source = "./virtual_machine"
  location = var.location
  resource_grp_name = azurerm_resource_group.resources.name
  subnet_ip = module.network.subnet_ip
  depends_on = [module.sql_firewall]

}


module "mysql" {
  source = "./database"
  admin_login = "praxz"
  admin_password = "1234567890@q"
  mysql-version = "8.0"
  mysql-sku-name = "GP_Gen5_4"
  mysql-storage = "5120"
  location = var.location
  resource_grp_name = azurerm_resource_group.resources.name
}

module "sql_firewall" {
  source = "./db_firewall"
  resource_grp_name = var.resource_grp_name
  server_name = module.mysql.sql_server
  start_ip = "0.0.0.0"
  end_ip = "255.255.255.255"
  depends_on = [module.mysql]
}
