[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)][string]$AccessKey,
    [Parameter(Mandatory=$true)][string]$StorageUNC,
    [Parameter(Mandatory=$true)][string]$ReportName,
    [Parameter(Mandatory=$true)][string[]]$packageslist
)
$date=Get-Date -Format "ddMMyyyy"
$connectTestResult = Test-NetConnection -ComputerName mystorage.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) 
{
    cmd.exe /C "cmdkey /add:`"mystorage.file.core.windows.net`" /user:`"localhost\mystorage`" /pass:`"$AccessKey`""
    # Mount the drive
    New-PSDrive -Name W -PSProvider FileSystem -Root "$StorageUNC" -Persist
    # Get the Software Status
    
    #################################### Verifying Installed Software on this machine $env:COMPUTERNAME ##########################################
    $packageInfo = New-Object System.Collections.ArrayList
    foreach($package in $packageslist)
    {
        $check = Get-Package -Name "$package" -ErrorAction SilentlyContinue
        if($check -eq $null)
        {
            
            $software = $package
            $installed = "NotInstalled"
            $ver=""
                
        }
        else
        {
            $Soft = Get-Package -Name "$package" -ErrorAction SilentlyContinue
            if($Soft -is [array])
            {
                $installed = "Installed"
                $software = $Soft[0].Name
                $ver=$Soft[0].Version
            }
            else{
                $installed = "Installed"
                $software = $Soft.Name
                $ver =$Soft.Version
            }
        }

        $packageInfo.Add([PSCustomObject]@{
            "Server"=$env:COMPUTERNAME
            "Software" = $software
            "Version"=$ver
            "Status"= $installed
                
        })
    }


    $packageInfo | Sort-Object -Property Software | Format-Table
    $s= Get-Random -Minimum 5 -Maximum 20;$s;sleep $s
    if($ReportName -eq "")
    {
        $file = "InstalledSoft_Report-$($date)"
    }
    else
    {
        $file = $ReportName

    }
    #$packageInfo | Export-Csv -Path "W:\$file.csv" -Append -NoTypeInformation -verbose
    $retries = 0
    $maxRetries = 20
    while ($retries -lt $maxRetries) {
    try {
        $packageInfo | Export-Csv -Path "W:\$file.csv" -Append -NoTypeInformation -verbose
        break
    } catch {
        $retries++
        Write-Host "Error: $($_.Exception.Message). Retrying in 5 seconds..."
        Start-Sleep -Seconds 5
    }
    }
    
    sleep 5
    Write-Output "Removing drive"
    sleep 2
    Remove-PSDrive -Name W
        
    
}
else 
{
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

