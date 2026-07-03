Import-Module ActiveDirectory

$FirstName = "Juan"
$LastName = "Perez"

$DisplayName = "$FirstName $LastName"
$SamAccountName = "jperez"
$UserPrincipalName = "jperez@empresa.local"

$Password = ConvertTo-SecureString "Temporal123!" -AsPlainText -Force

New-ADUser `
    -Name $DisplayName `
    -GivenName $FirstName `
    -Surname $LastName `
    -SamAccountName $SamAccountName `
    -UserPrincipalName $UserPrincipalName `
    -AccountPassword $Password `
    -Enabled $true `
    -ChangePasswordAtLogon $true

Write-Host "Usuario creado correctamente."
