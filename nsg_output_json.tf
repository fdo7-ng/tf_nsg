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

resource "azurerm_network_security_rule" "outbound_printers_udp" {
    name                        = "outbound_printers_udp"
    priority                    = 201
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Udp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "10.143.117.0/28"
    destination_address_prefixes = ["10.172.178.206/32","10.172.178.65/32"]
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "outbound_ad_domains_tcp" {
    name                        = "outbound_ad_domains_tcp"
    priority                    = 110
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "10.143.117.0/28"
    destination_address_prefixes = ["10.144.24.36","10.144.24.37"]
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "inbound_aks_nodepools_port_443" {
    name                        = "inbound_aks_nodepools_port_443"
    priority                    = 110
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefixes     = ["172.18.0.0/19","172.18.96.0/19","172.18.32.0/19","10.0.0.0/8"]
    destination_address_prefix  = "10.143.117.0/28"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "outbound_block_internal" {
    name                        = "outbound_block_internal"
    priority                    = 4096
    direction                   = "Outbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "10.0.0.0/8"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "rdp_from_wvd" {
    name                        = "rdp_from_wvd"
    priority                    = 200
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "3389"
    source_address_prefix       = "10.143.116.128/26"
    destination_address_prefix  = "10.143.117.0/28"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "port443_from_wvd" {
    name                        = "port443_from_wvd"
    priority                    = 202
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "10.143.116.128/26"
    destination_address_prefix  = "10.143.117.0/28"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "inbound_build_winrm" {
    name                        = "inbound_build_winrm"
    priority                    = 120
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "5986"
    source_address_prefix       = "172.31.4.0/25"
    destination_address_prefix  = "10.143.117.0/28"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "outbound_printers_tcp" {
    name                        = "outbound_printers_tcp"
    priority                    = 200
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "10.143.117.0/28"
    destination_address_prefixes = ["10.172.178.206/32","10.172.178.65/32"]
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "alb_probe_443" {
    name                        = "alb_probe_443"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "168.63.129.16"
    destination_address_prefix  = "10.143.117.0/28"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "outbound_ad_domains_udp" {
    name                        = "outbound_ad_domains_udp"
    priority                    = 111
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Udp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "10.143.117.0/28"
    destination_address_prefixes = ["10.144.24.36","10.144.24.37"]
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "port80_from_wvd" {
    name                        = "port80_from_wvd"
    priority                    = 201
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "10.143.116.128/26"
    destination_address_prefix  = "10.143.117.0/28"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "outbound_aks_ingress_controller" {
    name                        = "outbound_aks_ingress_controller"
    priority                    = 100
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "10.143.117.0/28"
    destination_address_prefix  = "10.143.103.0/27"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "inbound_block_all" {
    name                        = "inbound_block_all"
    priority                    = 4096
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}

