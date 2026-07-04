Import-Module ActiveDirectory

$User = Read-Host "Ingrese el nombre de usuario"

Unlock-ADAccount -Identity $User

Write-Host "La cuenta $User fue desbloqueada correctamente."