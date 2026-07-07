<#
.SYNOPSIS
Create Active Directory users from a CSV file.

.DESCRIPTION
Reads a CSV file and creates Active Directory users automatically.
Generates a log file and reports successful or failed operations.

Author: Aduer Andrés Castillo
GitHub: IAM-Labs
#>

Import-Module ActiveDirectory

$CSVPath = ".\CSV\Users.csv"
$LogPath = ".\Logs\CreateUsers.log"

if (!(Test-Path $CSVPath)) {
    Write-Host "CSV file not found." -ForegroundColor Red
    exit
}

if (!(Test-Path ".\Logs")) {
    New-Item -ItemType Directory -Path ".\Logs"
}

Start-Transcript -Path $LogPath -Append

$Users = Import-Csv $CSVPath

$total = $Users.Count
$counter = 0

foreach ($User in $Users) {

    $counter++

    Write-Progress `
        -Activity "Creating Active Directory Users" `
        -Status "$counter of $total" `
        -PercentComplete (($counter/$total)*100)

    try {

        if (Get-ADUser -Filter "SamAccountName -eq '$($User.SamAccountName)'" -ErrorAction SilentlyContinue) {

            Write-Host "$($User.SamAccountName) already exists." -ForegroundColor Yellow
            continue
        }

        $Password = ConvertTo-SecureString $User.Password -AsPlainText -Force

        New-ADUser `
            -Name $User.Name `
            -GivenName $User.FirstName `
            -Surname $User.LastName `
            -SamAccountName $User.SamAccountName `
            -UserPrincipalName $User.UserPrincipalName `
            -Path $User.OU `
            -Department $User.Department `
            -Title $User.Title `
            -EmailAddress $User.Email `
            -AccountPassword $Password `
            -Enabled $true `
            -ChangePasswordAtLogon $true

        Write-Host "User created: $($User.Name)" -ForegroundColor Green

    }

    catch {

        Write-Host "Error creating $($User.Name)" -ForegroundColor Red

        Write-Host $_.Exception.Message

    }

}

Stop-Transcript

Write-Host ""
Write-Host "Process completed successfully." -ForegroundColor Cyan
