#  Subnet
resource "azurerm_subnet" "bastion_host" {
  name                 = "${var.prefix}-bastion-host-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastion_host_subnet_cidr
}

#Bastion NSG 
resource "azurerm_network_security_group" "bastion_host" {
  name                = "${var.prefix}-bastion-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  security_rule {
    name                       = "Allow-SSH-22-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_source_address_prefix
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "bastion_host" {
  subnet_id                 = azurerm_subnet.bastion_host.id
  network_security_group_id = azurerm_network_security_group.bastion_host.id
}

# Bastion Host Linux VM Public IP
resource "azurerm_public_ip" "bastion_host" {
  name                = "${var.prefix}-bastion-host-vm-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# NIC 
resource "azurerm_network_interface" "bastion_vm1" {
  name                = "${var.prefix}-bastion-vm1-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.bastion_host.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion_host.id
  }
}

# Bastion VM1+OS disk
resource "azurerm_linux_virtual_machine" "bastion_vm1" {
  name                            = "${var.prefix}-bastion-vm-1"
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.vm_size
  admin_username                  = var.admin_username
  zone                            = var.availability_zone
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.bastion_vm1.id]
  tags                            = var.tags

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(pathexpand(var.admin_ssh_public_key_path))
  }

  os_disk {
    name                 = "${var.prefix}-bastion-vm1-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}