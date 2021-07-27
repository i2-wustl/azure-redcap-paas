# Replace these variables with your own values
Connect-AzAccount
Set-AzContext -Subscription "66fc3882-1a21-4787-9351-af5aa8eb3563"

$vaultName = "i2-redcap-keys"
$certificateName = "i2-redcap-dev-cert55461f00-ac1d-4810-868c-ff75287bebc0"
$pfxPath = [Environment]::GetFolderPath("Desktop") + "\$certificateName.pfx"
$password = "i2Secrets!"

$pfxSecret = Get-AzureKeyVaultSecret -VaultName $vaultName -Name $certificateName
$pfxUnprotectedBytes = [Convert]::FromBase64String($pfxSecret.SecretValueText)
$pfx = New-Object Security.Cryptography.X509Certificates.X509Certificate2
$pfx.Import($pfxUnprotectedBytes, $null, [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$pfxProtectedBytes = $pfx.Export([Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $password)
[IO.File]::WriteAllBytes($pfxPath, $pfxProtectedBytes)




