
resource "azurerm_resource_group" "rg" {
   name     = var.resource_group_name
   location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    name                = var.virtual_network_name
    address_space       = var.virtual_network_address_space
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_subnet" "subnet1" {
    name                 = var.subnet1_name
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = var.subnet1_address_space
}


resource "azurerm_subnet" "subnet2" {
    name                 = var.subnet2_name
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes       = var.subnet2_address_space
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "subnet1-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowWebTraffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80","443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg1tosubnet1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_network_security_group" "nsg2" {
  name                = "subnet2-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowWebTraffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["80","443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg2tosubnet2" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}

resource "azurerm_storage_account" "mystorageaccount" {
    name                        = var.storage_account_name
    resource_group_name         = azurerm_resource_group.rg.name
    location                    = "uksouth"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}

data "azurerm_key_vault" "keyvault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rsg_name
}

data "azurerm_key_vault_secret" "vmadminname" {
  name      = "vmadmin"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "vmadminpassword" {
  name      = "vmadminpassword"
  key_vault_id = data.azurerm_key_vault.keyvault.id
}


resource "azurerm_network_interface" "nic1" {
  name                = "vm1-nic1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "vm2-nic1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  name                = var.VM1_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = data.azurerm_key_vault_secret.vmadminname.value
  admin_password      = data.azurerm_key_vault_secret.vmadminpassword.value
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "vm2" {
  name                = var.VM2_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = data.azurerm_key_vault_secret.vmadminname.value
  admin_password      = data.azurerm_key_vault_secret.vmadminpassword.value
  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


