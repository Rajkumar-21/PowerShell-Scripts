# Path to the text file containing the list of FQDNs
$fqdnFilePath = "C:\temp\fqdns.txt"

# Read the FQDNs from the file (each FQDN should be on a separate line)
$fqdns = Get-Content -Path $fqdnFilePath

# Initialize an array to hold the results
$results = @()

# Loop through each FQDN and test the connection on port 443
foreach ($fqdn in $fqdns) {
    $status = "Failed" # Default status
    $result = Test-NetConnection -ComputerName $fqdn -Port 443 -WarningAction SilentlyContinue
    if ($result.TcpTestSucceeded) {
        $status = "Passed"
    }

    # Create a custom object with the desired properties
    $obj = New-Object PSObject -Property @{
        FQDN   = $fqdn
        Port   = $result.RemotePort
        Status = $status
        IP     = $result.RemoteAddress.IPAddressToString
    }

    # Add the custom object to the results array
    $results += $obj
}

# Output the results in a table format
$results | Format-Table -AutoSize
$results | Export-Csv C:\temp\fqdn.csv -NoTypeInformation
