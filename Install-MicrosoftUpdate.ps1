# Installing the PSWindowsUpdate Module which is required to perform the Microsoft Upgrade

if (-not (Get-Module -Name PSWindowsUpdate -ListAvailable -ErrorAction SilentlyContinue)) {
    Install-Module -Name PSWindowsUpdate -SkipPublisherCheck -Verbose -Force
    Add-WUServiceManager -MicrosoftUpdate -Confirm:$false
}
else
{
    Write-Output "PSWindowsUpdate Module Found..Importing PSWindowsUpdate Module..."
    Import-Module -Name PSWindowsUpdate
    Add-WUServiceManager -MicrosoftUpdate -Confirm:$false
}

# TO get the list of updates available for the machine
Get-WuList -MicrosoftUpdate

# To install the updates
Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot

<#
  Other Arguments availble for the Install-WindowsUpdate command:
  -KBArticleID
  -NotKBArticleID
  -IgnoreReboot
  -ScheduleReboot
  -UpdateType Driver/Software
  -DeploymentAction Installation/Uninstallation
 #>
