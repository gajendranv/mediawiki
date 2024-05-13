#### Parameters

$keyvaultname = "drupalkeyvault"
$location = "CentralIndia"
$keyvaultrg = "testdrupalrg"
$sshkeysecret = "akspubsshkey"
$spnclientid = "b6510afd-5940-4802-ac03-ed95010dd4c5"
$clientidkvsecretname = "spn-id"
$spnclientsecret = "jhE8Q~6_NhsL15E6WbJ56.mkuhf5buC2Epe20baP"
$spnkvsecretname = "spn-secret"
$spobjectID = "b6510afd-5940-4802-ac03-ed95010dd4c5"
$userobjectid = "b6510afd-5940-4802-ac03-ed95010dd4c5"


#### Create Key Vault

New-AzResourceGroup -Name $keyvaultrg -Location $location

New-AzKeyVault -Name $keyvaultname -ResourceGroupName $keyvaultrg -Location $location

Set-AzKeyVaultAccessPolicy -VaultName $keyvaultname -UserPrincipalName jyotsna.b@bourntec.com -PermissionsToSecrets get,set,delete,list

#### create an ssh key for setting up password-less login between agent nodes.

ssh-keygen  -f ~/.ssh/id_rsa_terraform


#### Add SSH Key in Azure Key vault secret

$pubkey = cat ~/.ssh/id_rsa_terraform.pub

$Secret = ConvertTo-SecureString -String $pubkey -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $sshkeysecret -SecretValue $Secret


#### Store service principal Client id in Azure KeyVault

$Secret = ConvertTo-SecureString -String $spnclientid -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $clientidkvsecretname -SecretValue $Secret


#### Store service principal Secret in Azure KeyVault

$Secret = ConvertTo-SecureString -String $spnclientsecret -AsPlainText -Force

Set-AzKeyVaultSecret -VaultName $keyvaultname -Name $spnkvsecretname -SecretValue $Secret


#### Provide Keyvault secret access to SPN using Keyvault access policy

Set-AzKeyVaultAccessPolicy -VaultName $keyvaultname -ServicePrincipalName $spobjectID -PermissionsToSecrets Get,Set
