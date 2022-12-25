# Import the AzureRM module
#Import-Module AzureRM

# Connect to Azure
Connect-AzureRmAccount -Credential $Credential

# Set the resource group name
$resourceGroup = "RG"

# Get all the VMs in the resource group
$vms = Get-AzureRMVM -ResourceGroupName $resourceGroup

# Create an empty array to store the VM info
$vmInfo = @()

# Loop through each VM
foreach($vm in $vms)
{
    # Get the VM's spec and tags
    $vmSpec = $vm.HardwareProfile
    $vmTags = $vm.Tags

    # Check if the VM is connected to Azure Monitor and Log Analytics
    $isConnectedToMonitor = $vm.DiagnosticsProfile.BootDiagnostics.Enabled
    $isConnectedToLogAnalytics = $vm.DiagnosticsProfile.LogAnalytics.WorkspaceId -ne $null

    # Create an object to store the VM info
    $vmData = [pscustomobject]@{
        "VM Name" = $vm.Name
        "VM Spec" = $vmSpec
        "VM Tags" = $vmTags
        "Connected to Azure Monitor" = $isConnectedToMonitor
        "Connected to Log Analytics" = $isConnectedToLogAnalytics
    }

    # Add the object to the array
    $vmInfo += $vmData
}

# Export the array to an Excel file
$vmInfo | Export-Excel -Path "C:\Users\rajkumar\Documents\Reports\AzureVM.csv"
