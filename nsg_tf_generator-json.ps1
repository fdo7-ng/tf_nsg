
<#
    This powershell script will generate a Terraform job to create NSG
    Descrition:
        Script will take JSON Input with NSG Rules and Generate and Terraform
        job to create NetworkSecurity Groups.
    Pre-Requisite:
        - Need NSG_Ruleset.json exported from Azure using Powershell.
        - Get-AzNetworkSecurity -Name XXX | Convertto-Json | Out-File -Path XXX
        Sample - Json
            [
                {
                    "Name": "AllowFTP",
                    "Etag": "W/\"0e2362fc-29ef-4241-8c20-324f2ed32b44\"",
                    "Protocol": "TCP",
                    "SourcePortRange": [
                    "*"
                    ],
                    "DestinationPortRange": [
                    "21"
                    ],
                    "SourceAddressPrefix": [
                    "10.164.129.100",
                    "10.164.129.101",
                    "10.164.129.102",
                    "10.164.129.103",
                    "12.197.215.0/27",
                    "96.77.155.0/29"
                    ],

    Update:
    -   There is problem with Terraform or ARM Templates when processing IP and Port ranges
        Exported field are all in are singular ie: source_port_range and values can be single *, or 80,443
        During Import It must be
        source_port_range = * 
        source_port_ranges = ["80", "443"]
        Need to write translation code to convert and replace the parameters.
    -   Data Imported from EXCEL behaves diferently, everything is a string. Need to split and rejoin.
        
#>

Write-Host "Script Started"

# $json_data = Get-Content "./sample.json" | Convertfrom-Json
$json_data = Get-Content "./nsg-print.json" | Convertfrom-Json

$resource_group_name = "arm-test-rg"
$network_security_group_name = "arm-test-nsg-del"

# Function to run list in string format.
# input "ip1,ip2"
# return ["ip1", "ip2"]
function convert_to_string($object_list){
    return $('["' + ($object_list -join '","' )+ '"]' )
}



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

foreach ($nsg in $json_data) {

#     $nsg_resource_content = @"
# resource "azurerm_network_security_rule" "$($nsg.Name)" {
#     name                        = "$($nsg.Name)"
#     priority                    = $($nsg.Priority)
#     direction                   = "$($nsg.Direction)"
#     access                      = "$($nsg.Access)"
#     protocol                    = "$($nsg.Protocol)"
#     source_port_range           = "$($nsg.SourcePortRange -join ",")"
#     destination_port_range      = $($nsg.DestinationPortRange -join ",")
#     source_address_prefixes       = ["$($nsg.SourceAddressPrefix -join """,""")"]
#     destination_address_prefix  = "$($nsg.DestinationAddressPrefix -join ",")"
#     resource_group_name         = data.azurerm_resource_group.resource.name
#     network_security_group_name = data.azurerm_network_security_group.nsg.name
# }
# "@
    
    $nsg_resource_content = @"
resource "azurerm_network_security_rule" "$($nsg.Name)" {
    name                        = "$($nsg.Name)"
    priority                    = $($nsg.Priority)
    direction                   = "$($nsg.Direction)"
    access                      = "$($nsg.Access)"
    protocol                    = "$($nsg.Protocol)"`n
"@
## Source Port Range
    if ($nsg.SourcePortRange.count -eq 1){
        $nsg_resource_content += @"
    source_port_range           = "$($nsg.SourcePortRange)"`n
"@       
    }else{
        $nsg_resource_content += @"
    source_port_ranges          = $('["' + ($nsg.SourcePortRange -join '","' )+ '"]' )`n
"@       
    }
## Destination Port Range
    if ($nsg.DestinationPortRange.count -eq 1){
        $nsg_resource_content += @"
    destination_port_range      = "$($nsg.DestinationPortRange)"`n
"@       
    }else{
        $nsg_resource_content += @"
    destination_port_ranges     = $('["' + ($nsg.DestinationPortRange -join '","' )+ '"]' )`n
"@           
    }


## Source Address Prefixes

if ($nsg.SourceAddressPrefix.count -eq 1){
    $nsg_resource_content += @"
    source_address_prefix       = "$($nsg.SourceAddressPrefix)"`n
"@       
}else{
    $nsg_resource_content += @"
    source_address_prefixes     = $('["' + ($nsg.SourceAddressPrefix -join '","' )+ '"]' )`n
"@       
}


## Destination Address Prefixes
    if ($nsg.DestinationAddressPrefix.count -eq 1){
    $nsg_resource_content += @"
    destination_address_prefix  = "$($nsg.DestinationAddressPrefix)"`n
"@       
    }else{
    $nsg_resource_content += @"
    destination_address_prefixes = $('["' + ($nsg.DestinationAddressPrefix -join '","' )+ '"]' )`n
"@       
    }


    $nsg_resource_content += @"
    resource_group_name         = data.azurerm_resource_group.resource.name
    network_security_group_name = data.azurerm_network_security_group.nsg.name
}
"@

    $master_nsg += $nsg_resource_content + "`n"
}


$master_nsg | Out-File -Path .\nsg_output_json.tf
Write-host "Saved file .\nsg_output.tf"
Write-Host "Script Finisshed"