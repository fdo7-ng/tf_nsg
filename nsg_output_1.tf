provider "azurerm" {
    features {}
  }

data "azurerm_resource_group" "resource" {
    name                    = "arm-test-rg"
}

data "azurerm_network_security_group" "nsg" {
    name                    =  "arm-test-nsg-del" 
    resource_group_name     =  data.azurerm_resource_group.resource.name
}

resource "azurerm_network_security_rule" "AllowFTP" {
    name                        = "AllowFTP"
    priority                    = 1900
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "TCP"
    source_port_range           = "*"
    destination_port_range      = "21"
    source_address_prefixes     = ["10.164.129.100","10.164.129.101","10.164.129.102","10.164.129.103","12.197.215.0/27","96.77.155.0/29"]
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "AllowRDP" {
    name                        = "AllowRDP"
    priority                    = 2000
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "TCP"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefixes     = ["10.164.10.0/24","10.164.74.0/24","10.144.128.0/20"]
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "AllowSMB" {
    name                        = "AllowSMB"
    priority                    = 2100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "TCP"
    source_port_range           = "*"
    destination_port_range      = "445"
    source_address_prefixes     = ["10.164.10.0/24","10.164.74.0/24","10.144.128.0/20","10.164.0.100","10.164.0.102"]
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "AllowInternalAccess" {
    name                        = "AllowInternalAccess"
    priority                    = 2200
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefixes     = ["10.144.128.0/20","10.144.112.0/20","10.170.208.0/20","10.170.192.0/20"]
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "AllowAzureCloud" {
    name                        = "AllowAzureCloud"
    priority                    = 2300
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "AzureCloud"
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "DenyRDPandSMB" {
    name                        = "DenyRDPandSMB"
    priority                    = 2400
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "TCP"
    source_port_range           = "*"
    destination_port_ranges     = ["445","3389"]
    source_address_prefix       = "*"
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "AllowVirtualNetwork" {
    name                        = "AllowVirtualNetwork"
    priority                    = 2500
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "VirtualNetwork"
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "AllowLoadBalancer" {
    name                        = "AllowLoadBalancer"
    priority                    = 2600
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "AzureLoadBalancer"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "AllowPublicAccessHttp" {
    name                        = "AllowPublicAccessHttp"
    priority                    = 2650
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_ranges     = ["80","443"]
    source_address_prefix       = "Internet"
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "DenyPublicAccess" {
    name                        = "DenyPublicAccess"
    priority                    = 2700
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "Internet"
    destination_address_prefix  = "VirtualNetwork"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}

