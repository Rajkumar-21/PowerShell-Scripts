$drive = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
$capacity = "{0:N2}" -f ($drive.Size / 1GB)
$used = "{0:N2}" -f (($drive.Size - $drive.FreeSpace) / 1GB)
$free = "{0:N2}" -f ($drive.FreeSpace / 1GB)

Write-Host "Total capacity: $capacity GB`nUsed capacity: $used GB`nFree space: $free GB"
