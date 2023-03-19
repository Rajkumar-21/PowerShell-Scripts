# Set the subscription context
#Set-AzContext -SubscriptionId "5b973f99-77df-4beb-b27d-aa0c70b8482c"
# Get the list of VMs in your resource group
$vms = Get-AzVM

# Create an empty array to store the VM details
$vmDetails = @()

# Loop through each VM and get the VM details
foreach ($vm in $vms) {
    # Get the VM configuration
    $vmConfig = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
    
    # Get the VM size
    $vmSize = $vmConfig.HardwareProfile.VmSize

    # Get the number of vCPUs
    $vCPUs = $vmConfig.HardwareProfile.VCpuCount

    # Get the amount of memory in GB
    $vRAM = $vmConfig.HardwareProfile.MemoryInMB/1024

    # Get the data disks attached to the VM
    $dataDisks = $vmConfig.StorageProfile.DataDisks

    # Loop through each data disk and get the size
    $dataDiskSizes = @()
    foreach ($dataDisk in $dataDisks) {
        $dataDiskSize = $dataDisk.DiskSizeGB
        $dataDiskSizes += $dataDiskSize
    }

    # Create a hashtable with the VM details
    $vmDetail = @{
        "VM Name" = $vm.Name
        "VM Size" = $vmSize
        "vCPUs" = $vCPUs
        "vRAM (GB)" = $vRAM
        "Data Disk Sizes (GB)" = $dataDiskSizes -join ', '
    }

    # Add the hashtable to the array of VM details
    $vmDetails += $vmDetail
}

# Export the VM details to a CSV file
$vmDetails | Export-Csv -Path "C:\temp\vmdetails.csv" -NoTypeInformation
