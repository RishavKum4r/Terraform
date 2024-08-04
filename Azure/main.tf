terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.93.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "dev-rg" {
  name     = "development-rg"
  location = "East US"
  tags = {
    Environment = "Development"
    Owner       = "Rishav Kumar"
  }
}

resource "azurerm_virtual_network" "dev-vn" {
  name                = "dev-network"
  resource_group_name = azurerm_resource_group.dev-rg.name
  location            = azurerm_resource_group.dev-rg.location

  address_space = ["10.119.0.0/16"]
  tags = {
    Environment = "Development"
    Owner       = "Rishav Kumar"
  }

}

resource "azurerm_subnet" "dev-sn" {
  name                 = "dev-subnet"
  resource_group_name  = azurerm_resource_group.dev-rg.name
  virtual_network_name = azurerm_virtual_network.dev-vn.name
  address_prefixes     = ["10.119.10.0/24"]
}

resource "azurerm_network_security_group" "dev-nsg" {
  name                = "dev-nsg"
  location            = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  tags = {
    Environment = "Development"
    Owner       = "Rishav Kumar"
  }
}

resource "azurerm_network_security_rule" "dev-nsrule" {
  name                        = "dev-netsecrule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dev-rg.name
  network_security_group_name = azurerm_network_security_group.dev-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "dev-sga" {
  subnet_id                 = azurerm_subnet.dev-sn.id
  network_security_group_id = azurerm_network_security_group.dev-nsg.id
}

resource "azurerm_public_ip" "dev-pip" {
  name                = "dev-publicip"
  resource_group_name = azurerm_resource_group.dev-rg.name
  location            = azurerm_resource_group.dev-rg.location
  allocation_method   = "Dynamic"

  tags = {
    Environment = "Development"
    Owner       = "Rishav Kumar"
  }
}

resource "azurerm_network_interface" "dev-nic" {
  name                = "dev-nic"
  location            = azurerm_resource_group.dev-rg.location
  resource_group_name = azurerm_resource_group.dev-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dev-sn.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev-pip.id
  }

  tags = {
    Environment = "Development"
    Owner       = "Rishav Kumar"
  }

}

resource "azurerm_linux_virtual_machine" "dev-vm" {
  name                  = "devlnxvm1"
  resource_group_name   = azurerm_resource_group.dev-rg.name
  location              = azurerm_resource_group.dev-rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.dev-nic.id]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/devlnxvmkey.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    Environment = "Development"
    Owner       = "Rishav Kumar"
  }
}