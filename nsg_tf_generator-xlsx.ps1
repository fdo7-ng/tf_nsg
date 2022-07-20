
<#
    This powershell script will generate a Terraform job to create NSG
    Descrition:
        Script will take EXCEL spreadsheet and output TF file for Terraform
    Reference Link to solve issue
    Update: 
    -   There is problem with Terraform or ARM Templates when processing IP and Port ranges
        Exported field are all in are singular ie: source_port_range and values can be single *, or 80,443
        During Import It must be
        source_port_range = * 
        source_port_ranges = ["80", "443"]
    -   Had to write translation code to translate and convert ports and IPs into correct format.
    -   Data Imported from EXCEL behaves diferently, everything is a string. Need to split and rejoin.
    - 
 

#>

# Function to run list in string format.
# input "ip1,ip2"
# return ["ip1", "ip2"]
function convert_to_string($object_list){
    return $('["' + ($object_list -join '","' )+ '"]' )
}


$excel_data = Import-Excel -Path '.\nsg_rule_sets\NSG Enterprise Ruleset 7-23-2021 v1.0.xlsx'

$resource_group_name = "arm-test-rg"
$network_security_group_name = "arm-test-nsg-del"

#NSG Terraform Template
$master_nsg = @"
provider "azurerm" {
    features {}
  }

data "azurerm_resource_group" "resource" {
    name                    = "$resource_group_name"
}

data "azurerm_network_security_group" "nsg" {
    name                    =  "$network_security_group_name" 
    resource_group_name     =  data.azurerm_resource_group.resource.name
}


"@

foreach ($nsg in $excel_data) {
$nsg
    $nsg_resource_content = @"
resource "azurerm_network_security_rule" "$($nsg.Name)" {
    name                        = "$($nsg.Name)"
    priority                    = $($nsg.Priority)
    direction                   = "$($nsg.Direction)"
    access                      = "$($nsg.Access)"
    protocol                    = "$($nsg.Protocol)"`n
"@
## Source Port Range
    if ($nsg.SourcePortRange.split(",").count -eq 1){
        $nsg_resource_content += @"
    source_port_range           = "$($nsg.SourcePortRange)"`n
"@       
    }else{
        $nsg_resource_content += @"
    source_port_ranges          = $( convert_to_string( $nsg.SourcePortRange.split(',') ) )`n
"@       
    }
## Destination Port Range
    if ($nsg.DestinationPortRange.split(",").count -eq 1){
        $nsg_resource_content += @"
    destination_port_range      = "$($nsg.DestinationPortRange)"`n
"@       
    }else{
        $nsg_resource_content += @"
        destination_port_ranges     = $( convert_to_string( $nsg.DestinationPortRange.split(',') ) )`n
"@           
    }


## Source Address Prefixes

if ($nsg.SourceAddressPrefix.split(",").count -eq 1){
    $nsg_resource_content += @"
    source_address_prefix       = "$($nsg.SourceAddressPrefix)"`n
"@       
}else{
    $nsg_resource_content += @"
    source_address_prefixes     = $( convert_to_string( $nsg.SourceAddressPrefix.split(',') ) )`n
"@       
}


## Destination Address Prefixes
    if ($nsg.DestinationAddressPrefix.split(",").count -eq 1){
    $nsg_resource_content += @"
    destination_address_prefix  = "$($nsg.DestinationAddressPrefix)"`n
"@       
    }else{
    $nsg_resource_content += @"
    source_address_prefixes     = $( convert_to_string( $nsg.DestinationAddressPrefix.split(',') ) )`n
"@       
    }


    $nsg_resource_content += @"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
"@
    
    $master_nsg += $nsg_resource_content + "`n"
}

$master_nsg | Out-File -Path .\nsg_output_xlsx.tf
