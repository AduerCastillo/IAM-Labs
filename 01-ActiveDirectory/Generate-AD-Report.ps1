<#
.SYNOPSIS
Generate Active Directory Health Report.

.DESCRIPTION
This script generates different Active Directory reports including:

- Enabled Users
- Disabled Users
- Locked Users
- Domain Admins Members

The reports are exported to CSV and HTML.

.AUTHOR
Aduer Andrés Castillo

.VERSION
1.0

.DATE
2026-07-08
#>

#---------------------------------------------------
# Variables
#---------------------------------------------------

$Date = Get-Date -Format "yyyyMMdd_HHmmss"

$OutputFolder = ".\Output"

$LogFolder = ".\Logs"

$LogFile = "$LogFolder\AD_Report_$Date.log"

if (!(Test-Path $OutputFolder))
{
    New-Item -ItemType Directory -Path $OutputFolder
}

if (!(Test-Path $LogFolder))
{
    New-Item -ItemType Directory -Path $LogFolder
}



