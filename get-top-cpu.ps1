# Get the list of processes with their CPU usage percentage
$processCpuUsage = Get-WmiObject Win32_PerfFormattedData_PerfProc_Process | 
    Where-Object { $_.Name -ne "_Total" -and $_.Name -ne "Idle" } | 
    Select-Object IDProcess, Name, PercentProcessorTime

# Get the list of processes with their owner information
$processOwners = Get-WmiObject Win32_Process | 
    ForEach-Object {
        $owner = $_.GetOwner()
        @{
            IDProcess = $_.ProcessID
            Username = if ($owner -ne $null) { $owner.User } else { "N/A" }
        }
    }

# Combine the CPU usage and owner information
$combinedInfo = foreach ($cpu in $processCpuUsage) {
    $owner = $processOwners | Where-Object { $_.IDProcess -eq $cpu.IDProcess }
    [PSCustomObject]@{
        ProcessName = $cpu.Name
        CPU_Percentage = $cpu.PercentProcessorTime
        Username = $owner.Username
    }
}

# Sort by CPU usage and select the top 10
$combinedInfo | Sort-Object CPU_Percentage -Descending | Select-Object -First 10 | Format-Table -AutoSize
