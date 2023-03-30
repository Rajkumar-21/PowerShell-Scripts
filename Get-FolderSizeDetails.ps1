Get-ChildItem -Path "C:\Users" -Directory | ForEach-Object {
    $folderSize = Get-ChildItem -Path $_.FullName -Recurse -File | Measure-Object -Property Length -Sum
    $_ | Select-Object @{Name="FolderName";Expression={$_.Name}}, @{Name="FolderSize";Expression={"{0:N2}" -f ($folderSize.Sum / 1MB) + " MB"}}
} | Format-Table -Autosize
