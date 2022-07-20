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

resource "azurerm_network_security_rule" "qualys-scan-services" {
    name                        = "qualys-scan-services"
    priority                    = 1100
    direction                   = ""
    access                      = "allow"
    protocol                    = "any"
    source_port_range           = "any"
    destination_port_range      = "*"
    source_address_prefixes     = ["10.3.200.47","10.54.44.176","10.54.44.180","10.111.25.63","10.111.25.166","10.133.25.181","10.136.107.121","10.143.69.9","10.146.51.8","10.148.223.20","10.148.223.21","10.148.223.22","10.148.223.23","10.164.148.69","10.164.148.69","10.164.148.70","10.164.148.71","10.164.148.72","10.164.148.73","10.164.148.74","10.164.148.75","10.164.148.76","10.164.148.77","10.164.148.78","10.166.0.196","10.166.0.197","10.166.0.198","10.166.0.199","10.166.0.200","10.172.19.32","10.172.112.150","10.220.226.19","10.230.16.173","10.230.16.247","10.230.97.164","10.230.108.6","10.238.218.70","10.238.218.71","10.238.218.72","10.238.218.73","172.30.200.38"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "tanium-services" {
    name                        = "tanium-services"
    priority                    = 1101
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["22","135","445","17472","17475","17486","17487","17488"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.111.25.56","10.173.161.28","10.173.161.29","10.173.161.156","10.164.8.147"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "mcafee-services" {
    name                        = "mcafee-services"
    priority                    = 1102
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["8081","8082","445"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.164.129.32/27","10.238.219.85","10.157.191.66","10.148.4.196","10.164.129.62","10.164.129.61"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "thycotic-services" {
    name                        = "thycotic-services"
    priority                    = 1103
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_range           = "22"
    destination_port_range      = "*"
    source_address_prefixes     = ["10.164.135.132","10.164.135.133"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "encase-services" {
    name                        = "encase-services"
    priority                    = 1104
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["22","4445","4446"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.54.44.31","10.54.44.32","10.164.101.133","10.164.101.132","10.54.44.22"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "active-directory-services-tcp" {
    name                        = "active-directory-services-tcp"
    priority                    = 1400
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["80","88","111","135","138","139","363","389","445","464","636","749","750","754","1024-5000","5722","5985","9389","49152-65535"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.164.8.74","10.164.8.75","10.164.8.76","10.164.8.77","10.165.8.10","10.165.8.11","10.165.8.12","10.164.8.68","10.164.8.69","10.165.8.4","10.165.8.5","10.165.8.10","10.164.133.197","10.164.133.196","10.165.133.196","10.165.133.197"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "active-directory-services-udp" {
    name                        = "active-directory-services-udp"
    priority                    = 1401
    direction                   = ""
    access                      = "allow"
    protocol                    = "udp"
    source_port_ranges          = ["88","111","123","137","138","389","445","464","749","750","2535","3268","49152-65535"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.164.8.74","10.164.8.75","10.164.8.76","10.164.8.77","10.165.8.10","10.165.8.11","10.165.8.12","10.164.8.68","10.164.8.69","10.165.8.4","10.165.8.5","10.165.8.10","10.164.133.197","10.164.133.196","10.165.133.196","10.165.133.197"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "sccm-services-tcp" {
    name                        = "sccm-services-tcp"
    priority                    = 1402
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["80","135","443","445","2701","3389","34400","34760","49152-65535"]
    destination_port_range      = "*"
    source_address_prefix       = "10.164.0.96/27"
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "sccm-services-udp" {
    name                        = "sccm-services-udp"
    priority                    = 1403
    direction                   = ""
    access                      = "allow"
    protocol                    = "udp"
    source_port_ranges          = ["9","25536","34324","34325","34335","34337","34343","34345","34760","34750",""]
    destination_port_range      = "*"
    source_address_prefix       = "10.164.0.96/27"
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "redhat-satellite-services" {
    name                        = "redhat-satellite-services"
    priority                    = 1404
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["22","443"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.111.25.160","10.133.25.57","10.164.149.69"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "beyond-trust-services" {
    name                        = "beyond-trust-services"
    priority                    = 1405
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_range           = "443"
    destination_port_range      = "*"
    source_address_prefix       = "10.133.25.70-72"
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "backup-services" {
    name                        = "backup-services"
    priority                    = 1406
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["12801","12800"]
    destination_port_range      = "*"
    source_address_prefix       = "10.164.133.96/27"
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "bastion-services" {
    name                        = "bastion-services"
    priority                    = 1407
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["3389","22"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.164.10.30","10.164.10.26","10.164.10.24","10.164.10.11","10.164.10.9","10.164.10.7","10.164.10.10","10.164.10.12","140.164.10.8","10.164.10.13","10.164.149.164","10.164.149.165","10.164.136.64/26"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "scom-services-tcp" {
    name                        = "scom-services-tcp"
    priority                    = 1700
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["22","161","162","445","1270","5723","5724","49152-65535","135-139"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.111.39.15","10.118.12.164","10.118.12.19","10.133.39.15","10.138.4.69","10.148.42.70","10.148.6.56","10.148.96.17","10.148.96.18","10.148.96.19","10.15.3.13","10.164.148.40","10.164.148.41","10.164.148.42","10.164.148.43","10.164.148.44","10.164.148.49","10.164.148.50","10.164.148.51","10.164.148.52","10.164.148.53","10.164.148.54","10.164.148.55","10.164.148.56","10.164.148.57","10.164.2.29","10.173.134.70","10.173.167.18","10.230.48.125","10.238.153.215","10.6.0.97","172.16.190.7","10.164.37.80","10.164.37.81","10.164.37.82","10.164.37.83","10.164.37.72","10.164.37.73","10.164.37.74","10.164.37.75","10.164.37.76","10.164.37.77","10.111.39.16","10.164.148.36","10.164.148.37","10.164.148.38"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "scom-services-udp" {
    name                        = "scom-services-udp"
    priority                    = 1701
    direction                   = ""
    access                      = "allow"
    protocol                    = "udp"
    source_port_ranges          = ["445","137-139"]
    destination_port_range      = "*"
    source_address_prefixes     = ["10.111.39.15","10.118.12.164","10.118.12.19","10.133.39.15","10.138.4.69","10.148.42.70","10.148.6.56","10.148.96.17","10.148.96.18","10.148.96.19","10.15.3.13","10.164.148.40","10.164.148.41","10.164.148.42","10.164.148.43","10.164.148.44","10.164.148.49","10.164.148.50","10.164.148.51","10.164.148.52","10.164.148.53","10.164.148.54","10.164.148.55","10.164.148.56","10.164.148.57","10.164.2.29","10.173.134.70","10.173.167.18","10.230.48.125","10.238.153.215","10.6.0.97","172.16.190.7","10.164.37.80","10.164.37.81","10.164.37.82","10.164.37.83","10.164.37.72","10.164.37.73","10.164.37.74","10.164.37.75","10.164.37.76","10.164.37.77","10.111.39.16","10.164.148.36","10.164.148.37","10.164.148.38"]
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "solarwinds" {
    name                        = "solarwinds"
    priority                    = 1702
    direction                   = ""
    access                      = "allow"
    protocol                    = "udp"
    source_port_range           = "161"
    destination_port_range      = "*"
    source_address_prefix       = "10.164.2.201"
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "" {
    name                        = ""
    priority                    = 
    direction                   = ""
    access                      = ""
    protocol                    = ""
    destination_port_range      = "*"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "IntraSubnet" {
    name                        = "IntraSubnet"
    priority                    = 3000
    direction                   = ""
    access                      = "allow"
    protocol                    = "any"
    source_port_range           = "0-65535"
    destination_port_range      = "*"
    source_address_prefix       = "<variable.subnet.nsg.is.assigned.to>"
    destination_address_prefix  = "<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "standard-enterprise-application-tcp" {
    name                        = "standard-enterprise-application-tcp"
    priority                    = 3050
    direction                   = ""
    access                      = "allow"
    protocol                    = "tcp"
    source_port_ranges          = ["80","443","8080","8083","2598"]
    destination_port_range      = "*"
    source_address_prefix       = "10.0.0.0/8"
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "standard-enterprise-application-udp" {
    name                        = "standard-enterprise-application-udp"
    priority                    = 3051
    direction                   = ""
    access                      = "allow"
    protocol                    = "udp"
    source_port_range           = "34325"
    destination_port_range      = "*"
    source_address_prefix       = "10.0.0.0/8"
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "AzureLoadBalancer" {
    name                        = "AzureLoadBalancer"
    priority                    = 4000
    direction                   = ""
    access                      = "allow"
    protocol                    = "any"
    source_port_range           = "0-65535"
    destination_port_range      = "*"
    source_address_prefix       = "AzureLoadBalancer"
    destination_address_prefix  = "0.0.0.0/0"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "block-rdp-ssh" {
    name                        = "block-rdp-ssh"
    priority                    = 4095
    direction                   = ""
    access                      = "deny"
    protocol                    = "tcp"
    source_port_ranges          = ["3389","22"]
    destination_port_range      = "*"
    source_address_prefix       = "any"
    destination_address_prefix  = "
<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "deny" {
    name                        = "deny"
    priority                    = 4096
    direction                   = ""
    access                      = "deny"
    protocol                    = "any"
    source_port_range           = "any"
    destination_port_range      = "*"
    source_address_prefixes     = ["10.0.0.0/8","192.168.0.0/16","172.16.0.0/12"]
    destination_address_prefix  = "<variable.subnet.nsg.is.assigned.to>"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}

