Import-Module ActiveDirectory

$User = Read-Host "Ingrese el nombre de usuario"

Disable-ADAccount -Identity $User

Write-Host "La cuenta $User fue deshabilitada correctamente."