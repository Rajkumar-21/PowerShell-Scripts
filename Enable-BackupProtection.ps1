[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)][string[]]$vmNames,
    [Parameter(Mandatory = $true)][string]$rgName,
    [Parameter(Mandatory = $true)][string]$policyName,
    [Parameter(Mandatory = $true)][string]$vault
)


foreach($vmName in $vmNames)

{
    az backup protection enable-for-vm --resource-group $rgName --vault-name $vault --vm $vmName --policy-name $policyName

}
