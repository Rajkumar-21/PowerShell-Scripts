# Get a list of all the installed versions of the .NET Framework on the system
$dotNetVersions = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
    Get-ItemProperty -Name Version, Release -ErrorAction SilentlyContinue |
    Where-Object { $_.PSChildName -Match '^(?!S)\p{L}' } |
    Select-Object Version, Release

# Check if any of the installed .NET Framework versions have a version number equal to or higher than 4.8
$dotNet48OrHigherInstalled = $false
$dotNetLatestVersion = [System.Version]::Parse('4.8')
foreach ($dotNetVersion in $dotNetVersions) {
if ([System.Version]::Parse($dotNetVersion.Version) -ge [System.Version]::Parse('4.8')) {
    $dotNet48OrHigherInstalled = $true
    # Check if the current version is higher than the previously stored version
    $VMdotNetVersion = $dotNetVersion.Version
}
}
  
# If a version of .NET Framework 4.8 or higher is not installed, proceed with the installation
if (!$dotNet48OrHigherInstalled)
{
    # Perform action for "dotnet"
    if(Test-Path -Path "C:\temp\Softwares\ndp48-web.exe"){
    #Start-Process "C:\temp\Softwares\ndp48-web.exe" -ArgumentList "/q /norestart" -wait -PassThru -Verbose
    Write-host "Installation of dotnet completed" -foregroundColor Green
    }
    else{
    Write-Host "Unable to find: C:\temp\Softwares\ndp48-web.exe" -ForegroundColor Red
    }
}
else{
Write-Host "Dotnet already installed on this VM and version: $VMdotNetVersion"
    
}

