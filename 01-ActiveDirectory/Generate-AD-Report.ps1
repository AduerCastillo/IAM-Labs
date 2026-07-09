<#
.SYNOPSIS
    Generate Active Directory Health Report

.DESCRIPTION
    Generates Active Directory reports:
    - Enabled Users
    - Disabled Users
    - Locked Users
    - Domain Admins Members

.AUTHOR
    Aduer Andrés Castillo

.VERSION
    1.0
#>

#=====================================================
# VARIABLES
#=====================================================

$Date = Get-Date -Format "yyyyMMdd_HHmmss"

$OutputFolder = ".\Output"
$LogFolder = ".\Logs"

$LogFile = "$LogFolder\AD_Report_$Date.log"

#=====================================================
# CREATE FOLDERS
#=====================================================

if (!(Test-Path $OutputFolder)) {
    New-Item -ItemType Directory -Path $OutputFolder | Out-Null
}

if (!(Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder | Out-Null
}

#=====================================================
# LOG FUNCTION
#=====================================================

function Write-Log {

    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    $Entry = "$Time [$Level] $Message"

    Add-Content -Path $LogFile -Value $Entry

    Write-Host $Entry

}

#=====================================================
# SCRIPT START
#=====================================================

Write-Log "========================================="
Write-Log "Generate Active Directory Report Started"
Write-Log "========================================="

#=====================================================
# IMPORT ACTIVE DIRECTORY MODULE
#=====================================================

try {

    if (!(Get-Module -ListAvailable ActiveDirectory)) {
        throw "ActiveDirectory module is not installed."
    }

    Import-Module ActiveDirectory

    Write-Log "Active Directory module loaded successfully."

}
catch {

    Write-Log $_.Exception.Message "ERROR"

    exit

}

#=====================================================
# ENABLED USERS
#=====================================================

Write-Progress -Activity "Generating Reports" `
               -Status "Enabled Users" `
               -PercentComplete 20

Write-Log "Exporting enabled users..."

Get-ADUser -Filter {Enabled -eq $true} `
-Properties Department,EmailAddress |
Select-Object Name,
              SamAccountName,
              Department,
              EmailAddress |
Export-Csv "$OutputFolder\EnabledUsers.csv" `
-NoTypeInformation

Write-Log "Enabled users exported."

#=====================================================
# DISABLED USERS
#=====================================================

Write-Progress -Activity "Generating Reports" `
               -Status "Disabled Users" `
               -PercentComplete 40

Write-Log "Exporting disabled users..."

Get-ADUser -Filter {Enabled -eq $false} |
Select Name,
       SamAccountName |
Export-Csv "$OutputFolder\DisabledUsers.csv" `
-NoTypeInformation

Write-Log "Disabled users exported."

#=====================================================
# LOCKED USERS
#=====================================================

Write-Progress -Activity "Generating Reports" `
               -Status "Locked Users" `
               -PercentComplete 60

Write-Log "Exporting locked users..."

Search-ADAccount -LockedOut |
Select Name,
       SamAccountName |
Export-Csv "$OutputFolder\LockedUsers.csv" `
-NoTypeInformation

Write-Log "Locked users exported."

#=====================================================
# DOMAIN ADMINS
#=====================================================

Write-Progress -Activity "Generating Reports" `
               -Status "Domain Admins" `
               -PercentComplete 80

Write-Log "Exporting Domain Admins..."

Get-ADGroupMember "Domain Admins" |
Select Name,
       SamAccountName,
       ObjectClass |
Export-Csv "$OutputFolder\DomainAdmins.csv" `
-NoTypeInformation

Write-Log "Domain Admins exported."

#=====================================================
# SUMMARY
#=====================================================

Write-Progress -Activity "Generating Reports" -Completed

Write-Log "========================================="
Write-Log "Report completed successfully."
Write-Log "Reports saved in: $OutputFolder"
Write-Log "Log file: $LogFile"
Write-Log "========================================="

Write-Host ""
Write-Host "==============================================="
Write-Host " Active Directory Report Completed Successfully"
Write-Host "==============================================="
Write-Host ""
Write-Host "Reports Folder : $OutputFolder"
Write-Host "Log File       : $LogFile"
Write-Host ""




