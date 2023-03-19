param (
  [string[]]$VMNames
)

# First, connect to your Azure account

# Then, get the list of virtual machines in the subscription
$vms = Get-AzVM | Where-Object { $_.Name -in $VMNames }

# For each virtual machine, get the necessary details and create a custom object
$vmDetails = foreach ($vm in $vms) {
  $vmName = $vm.Name
  $vmSize = $vm.HardwareProfile.VmSize
  $vcpu = [int]$vmSize.Split("_")[2]
  $vmemory = [int]$vmSize.Split("_")[3].Substring(0,2)
  $disks = $vm.StorageProfile.DataDisks
  $diskDetails = foreach ($disk in $disks) {
    [PSCustomObject]@{
      DiskSize = $disk.DiskSizeGB
      Tier = if ($disk.ManagedDisk.StorageAccountType -eq "Standard_LRS") {"HDD"} else {"SSD"}
    }
  }
  [PSCustomObject]@{
    VMName = $vmName
    VMSize = $vmSize
    VCPU = $vcpu
    VMemory = $vmemory
    DiskDetails = $diskDetails
  }
}

# Output the results
$vmDetails | Select-Object VMName, VMSize, VCPU, VMemory, DiskDetails | Format-Table
