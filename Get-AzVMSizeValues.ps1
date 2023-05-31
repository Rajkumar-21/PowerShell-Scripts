$packageInfo = New-Object System.Collections.ArrayList
$azvms=Get-AzVM

foreach($vm in $azvms)

{
    $azvm = Get-AzVM -VMName $vm.Name
    $vmsize = $azvm.HardwareProfile.VmSize
    $CoreSizes=Get-AzVMSize -VMName $vm.Name -ResourceGroupName $azvm.ResourceGroupName | where{$_.Name -eq $vmsize}
    $cpu=$CoreSizes.NumberOfCores
    $memory=$CoreSizes.MemoryInMB
    $packageInfo.Add([PSCustomObject]@{
        "Server"=$vm.Name
        "VmSize" = $vmsize
        "CPUCores"=$cpu
        "MemoryInMB"= $memory
    })


}

# This variable has the all the vm with CPU and Memory values in MB
$packageInfo
