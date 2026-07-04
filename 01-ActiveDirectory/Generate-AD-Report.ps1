Import-Module ActiveDirectory

Get-ADUser -Filter * -Properties DisplayName, Enabled, Department |
Select-Object DisplayName, SamAccountName, Department, Enabled |
Export-Csv ".\Reporte_Usuarios_AD.csv" -NoTypeInformation -Encoding UTF8

Write-Host "Reporte generado correctamente."