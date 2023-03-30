Get-Process -IncludeUserName -ProcessName myprocess -ErrorAction SilentlyContinue |
Select-Object Name, UserName, @{Name='StartTime';Expression={$_.StartTime.ToLocalTime().ToString('yyyy-MM-dd HH:mm:ss')}} , @{Name='Duration';Expression={New-TimeSpan $_.StartTime}} |
Select-Object Name, UserName, StartTime, @{Name='Duration';Expression={$_.Duration.ToString('hh\:mm\:ss')}} |
Format-Table -AutoSize
