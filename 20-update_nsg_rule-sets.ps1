
<#
    This powershell script will generate a Terraform job to create NSG
    Descrition:
        Script will take EXCEL spreadsheet and output TF file for Terraform
    Reference Link to solve issue
    Update: 

 

#>
# param(
#     [Parameter(Mandatory=$true)]
#     [string]$ResourceGroupName,
#     [Parameter(Mandatory=$true)]
#     [string]$NetworkSecurityGroupName

# )

# Global Variable with EXCEL RuleSet
$global:excel_data = Import-Excel -Path '.\nsg_rule_sets\NSG Enterprise Ruleset 7-23-2021-edited.xlsx'


# Function to run list in string format.
# input "ip1,ip2"
# return ["ip1", "ip2"]
function convert_to_string($object_list){
    return $('["' + ($object_list -join '","' )+ '"]' )
}

function Get-AssociatedSubnet{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [Microsoft.Azure.Commands.Network.Models.PSNetworkSecurityGroup] $NetworkSecurityGroup
    )
    <#
        .SYNOPSIS
        Returns the address sprefix of subnet.

        .DESCRIPTION
        Returns the address sprefix of subnet.

        .PARAMETER NetworkSecurityGroup
        Specifies the Network Security Group. Most be NSG object Type

        .EXAMPLE
        PS> Get-AssociatedSubnet -NetworkSecurityGroup $nsg
        10.10.2.0/24
    #>

    $subnet_id = $nsg.Subnets[0].Id
    $subnet_name = $subnet_id.split("/") | select -last 1
    $ResourceGroupName = $subnet_id.split("/")[4]
    $vnet_name = $subnet_id.split("/")[8]
    $virtual_network = get-AzVirtualNetwork -Name $vnet_name -ResourceGroupName $ResourceGroupName
    $subnet_config = Get-AzVirtualNetworkSubnetConfig -Name $subnet_name -VirtualNetwork $virtual_network
    if ($subnet_config.AddressPrefix.count -gt 0){
        return $subnet_config.AddressPrefix
    }else {
        return $null
    }
}




function Update-NSGRuleSet{
    param(
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        [Parameter(Mandatory=$true)]
        [string]$NetworkSecurityGroupName

    )

    #create rule config
    foreach ($rule in $excel_data) {
        $rule
        $nsg = Get-AzNetworkSecurityGroup -Name $NetworkSecurityGroupName -ResourceGroupName $ResourceGroupName
        $check_rule = $nsg | Get-AzNetworkSecurityRuleConfig -Name $rule.Name -ErrorAction SilentlyContinue

        if ($check_rule){
            Write-Host "[$($rule.Name)] - Already Exist" -foreground yellow
            # Write-Host "[$($rule.Name)] -  Removing Rule " -foreground RED
            # Remove-AzNetworkSecurityRuleConfig -Name $rule.Name -NetworkSecurityGroup $nsg | out-null
            # $nsg | Set-AzNetworkSecurityGroup
        }else{
            
            Write-Host "[$($rule.Name)] - Creating Rule" -foreground green

            if ($rule.SourceAddressPrefix -match "<variable.subnet.nsg.is.assigned.to>" ){
                $sourceaddressprefix = Get-AssociatedSubnet $nsg
            }else{
                $sourceaddressprefix = ($rule.SourceAddressPrefix -split ',')
            }
            if ($rule.SourceAddressPrefix -match "<variable.subnet.nsg.is.assigned.to>" ){
                $destinationaddressprefix = Get-AssociatedSubnet $nsg
            }else{
                $destinationaddressprefix = ($rule.DestinationAddressPrefix -split ',')
            }

            $nsg | Add-AzNetworkSecurityRuleConfig -Name $rule.Name `
                -Access $rule.Access -Protocol $rule.Protocol `
                -Direction $rule.Direction -Priority $rule.Priority `
                -SourceAddressPrefix $sourceaddressprefix `
                -SourcePortRange ($rule.SourcePortRange -split ',') `
                -DestinationAddressPrefix $destinationaddressprefix `
                -DestinationPortRange ($rule.DestinationPortRange -split ',') |
            Set-AzNetworkSecurityGroup | OUT-NULL
        }
    }
}

#Manual OverRide - HardCode Values
Update-NSGRuleSet -ResourceGroupName "FNF-RG-NGX-Sandbox" -NetworkSecurityGroupName "nsg_code_testing"