
<#
Connect-AzAccount -UseDeviceAuthentication
Or
Authenticate to Azure using a service principal or user account
Connect-AzAccount -ServicePrincipal -TenantId <your-tenant-id> -ApplicationId <your-application-id> -CertificateThumbprint <your-certificate-thumbprint>
#>

# Import the Azure PowerShell module
Import-Module Az.KeyVault

# Define variables for the Key Vault name and secret name pattern
$keyVaultName = "KeyVaultName"
$secretNamePattern = "SecretNamePattern*"


# Get the secrets whose name matches the pattern
$secrets = Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $secretNamePattern


# Iterate through the secrets and display their values
foreach ($secret in $secrets) {
    $secretValueSecureString = (Get-AzKeyVaultSecret -VaultName $keyVaultName -Name $secret.Name).SecretValue
    $secretValuePlainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secretValueSecureString))
    Write-Host "Secret name: $($secret.Name), Secret value: $($secretValuePlainText)"
}
