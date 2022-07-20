# PowerShell Script to Generate Terraform Job 

Purpose of this script is to create a Terraform Job for Azure NSG creation.
Takes as input a JSON or Excel spreadsheet containing all the NSG rules set.

# Requirement

- Requires -Module ImportExcel

# Generate the NSG Json or Excel File

Command to export NSG ruleset into a json NSG ruleset:
(Get-AzNetworkSecurityGroup -Name nsg-print-dev-eus2-01 ).SecurityRules | ConvertTo-Json | Out-File .\nsg-print.json


# Generate the NSG Excel Output

When NSG ruleset to Excel, need to use 'join' function to eliminate objects or collections from the CSV. Sample code below.

```
$nsg_rule_set = Get-AzNetworkSecurityGroup -Name nsg-print-dev-eus2-01

$nsg_rule_set.SecurityRules | Select-Object -Property Name, `
            Description, `
            Protocol, `
            @{Name='SourcePortRange';Expression={[string]::join(';', ($_.SourcePortRange))}}, `
            @{Name='DestinationPortRange';Expression={[string]::join(';', ($_.DestinationPortRange))}}, `
            @{Name='SourceAddressPrefix';Expression={[string]::join(';', ($_.SourceAddressPrefix))}}, `
            @{Name='DestinationAddressPrefix';Expression={[string]::join(';', ($_.DestinationAddressPrefix))}}, `
            Access, `
            Priority, `
            Direction, `
            ProvisioningState, `
            @{Name='SourceApplicationSecurityGroups';Expression={[string]::join(';', ($_.SourceApplicationSecurityGroups))}}, `
            @{Name='DestinationApplicationSecurityGroups';Expression={[string]::join(';', ($_.DestinationApplicationSecurityGroups))}}, `
            SourceApplicationSecurityGroupsText, `
            DestinationApplicationSecurityGroupsText, `
            Etag, `
            Id | Export-Excel test.xlsx -autosize -autofilter

```

# Script - nsg_tf_generateor-json.ps1

# 20-update_nsg_rule-set.ps1

This script will add the rulesets in the EXCEL_DATA sheet
