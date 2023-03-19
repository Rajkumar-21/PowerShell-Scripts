# Define functions for each option
function PowerBi {
  # Perform action for "PowerBi"
    Start-Process "C:\temp\Softwares\PBIDesktopSetup_x64.exe" -ArgumentList "/q /norestart ACCEPT_EULA=1" -wait -PassThru -Verbose
    Write-host "Installation of PowerBi completed" -foregroundColor Green
  
}

function StorageExplorer {
  # Perform action for "StorageExplorer"
    Start-Process "C:\temp\Softwares\StorageExplorer.exe" -ArgumentList "/VERYSILENT /NORESTART /ALLUSERS" -wait -PassThru -Verbose
    Write-host "Installation of StorageExplorer completed" -foregroundColor Green

}

function Chrome {
  # Perform action for "Chrome"
    Start-Process "C:\temp\Softwares\ChromeSetup.exe" -ArgumentList "/silent /install" -wait -PassThru -Verbose
    Write-host "Installation of Chrome completed" -foregroundColor Green  
}

function SSMS {
  # Perform action for "SSMS"
    Start-Process "C:\temp\Softwares\SSMS-Setup-ENU.exe" -ArgumentList "/install /quiet /norestart" -wait -PassThru -Verbose
    Write-host "Installation of SSMS completed" -foregroundColor Green 
   
}

function 7Zip {
  # Perform action for "7Zip"
    Start-Process "C:\temp\Softwares\7z2201-x64.exe" -ArgumentList "/S" -wait -PassThru -Verbose
    Write-host "Installation of 7Zip completed" -foregroundColor Green
}

function dotnet {
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
        Start-Process "C:\temp\Softwares\ndp48-web.exe" -ArgumentList "/q /norestart" -wait -PassThru -Verbose
        Write-host "Installation of dotnet completed" -foregroundColor Green
      }
      else{
        Write-Host "Unable to find: C:\temp\Softwares\ndp48-web.exe" -ForegroundColor Red
      }
  }
  else{
    Write-Host "Dotnet already installed on this VM and version: $VMdotNetVersion"
    
  }

}

function Office {
  # Perform action for "Office"
    Start-Process "C:\temp\Softwares\Office\setup.exe" -Wait -ArgumentList '/config "C:\temp\Softwares\Office\CustomConfig.xml"' -PassThru
    Write-host "Installation of Office completed" -foregroundColor Green
}

function Edge {
  # Perform action for "BluePrism"
    Write-host "Installing Edge silently, please wait.. on $env:COMPUTERNAME" -foregroundColor Yellow
    Start-Process "C:\temp\Softwares\MicrosoftEdgeSetup.exe" -ArgumentList "/silent /install" -wait -PassThru
    Write-host "Installation of Edge completed" -foregroundColor Green
}
