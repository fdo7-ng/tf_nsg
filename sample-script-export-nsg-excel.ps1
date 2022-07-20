#Requires -Module ImportExcel

# Sample of Manual Export

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




