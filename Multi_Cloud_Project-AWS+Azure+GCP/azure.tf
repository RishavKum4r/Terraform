resource "azurerm_resource_group" "BITS-Project-Azure-RG" {
  name     = "BITS-Demo-Project-RG"
  location = "East US"
}

resource "azurerm_virtual_network" "BITS-Project-Azure-VN" {
  name                = "BITS-Demo-Project-VN"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.BITS-Project-Azure-RG.location
  resource_group_name = azurerm_resource_group.BITS-Project-Azure-RG.name
}

resource "azurerm_subnet" "BITS-Project-Azure-Subnet" {
  name                 = "BITS-Demo-Project-Subnet"
  resource_group_name  = azurerm_resource_group.BITS-Project-Azure-RG.name
  virtual_network_name = azurerm_virtual_network.BITS-Project-Azure-VN.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "BITS-Project-Azure-NI" {
  name                = "BITS-Demo-Project-NIC"
  location            = azurerm_resource_group.BITS-Project-Azure-RG.location
  resource_group_name = azurerm_resource_group.BITS-Project-Azure-RG.name

  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.BITS-Project-Azure-Subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.BITS-Project-Azure-PIP.id
  }
}

resource "azurerm_public_ip" "BITS-Project-Azure-PIP" {
  name                = "BITS-Demo-Project-IP"
  location            = azurerm_resource_group.BITS-Project-Azure-RG.location
  resource_group_name = azurerm_resource_group.BITS-Project-Azure-RG.name
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "BITS-Project-Azure-VM" {
  name                  = "BITS-Demo-Project-VM"
  location              = azurerm_resource_group.BITS-Project-Azure-RG.location
  resource_group_name   = azurerm_resource_group.BITS-Project-Azure-RG.name
  network_interface_ids = [azurerm_network_interface.BITS-Project-Azure-NI.id]
  size                  = "Standard_B1s"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name  = "BITSDemoVM"
  admin_username = "BITSadm"

  admin_ssh_key {
    username   = "BITSadm"
    public_key = file("~/.ssh/devlnxvmkey.pub")
  }

  disable_password_authentication = true
}