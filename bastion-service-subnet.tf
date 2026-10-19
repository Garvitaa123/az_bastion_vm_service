resource "azurerm_subnet" "bastion_service" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_service_subnet_cidr
}

#Bastion Service Public IP 
resource "azurerm_public_ip" "bastion_service" {
  name                = "${var.prefix}-bastion-service-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

#Azure Bastion Service
resource "azurerm_bastion_host" "bastion_service" {
  name                = "${var.prefix}-azure-bastion"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  tags                = var.tags

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_service.id
    public_ip_address_id = azurerm_public_ip.bastion_service.id
  }
}
