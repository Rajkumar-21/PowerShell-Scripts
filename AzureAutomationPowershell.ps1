[CmdletBinding()]
Param(
    [Parameter(Mandatory = $true)][string]$vmName,
    [Parameter(Mandatory = $true)][string]$rgName
)

 # Using the Identity method
Write-Output "Connecting to azure via  Connect-AzAccount -Identity -AccountId <ClientId of USI>"  
Connect-AzAccount -Identity -AccountId  "Identiy-ClientId"
Write-Output "Successfully connected with Automation account's Managed Identity" 

$azvm=Get-AzVM -ResourceGroupName $rgName -Name $vmName -Verbose
$vmsize = $azvm.HardwareProfile.VmSize
$CoreSizes=Get-AzVMSize -VMName $azvm.Name -ResourceGroupName $azvm.ResourceGroupName | where{$_.Name -eq $vmsize}
$cpu=$CoreSizes.NumberOfCores
$memory=$CoreSizes.MemoryInMB
Write-Output $azvm.Name
Write-Output $vmsize
Write-Output $cpu
Write-Output $memory
