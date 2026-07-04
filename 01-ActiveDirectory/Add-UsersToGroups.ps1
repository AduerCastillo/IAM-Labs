Import-Module ActiveDirectory

$User = Read-Host "Ingrese el nombre del usuario"
$Group = Read-Host "Ingrese el nombre del grupo"

Add-ADGroupMember -Identity $Group -Members $User

Write-Host "El usuario $User fue agregado al grupo $Group correctamente."