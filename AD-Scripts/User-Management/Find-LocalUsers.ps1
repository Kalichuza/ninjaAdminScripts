
<#PSScriptInfo

.VERSION 1.0.1

.GUID 87feab90-f2fc-4b55-81cc-2cfe5f777326

.AUTHOR Kalichuza

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 This script will find all local users on AD machine by OU. Then it will output their Admin status in consol and/or in CSV 

#> 
<#
.SYNOPSIS
    Queries all computers in a specified Organizational Unit (OU) and checks for active local accounts and their administrator status.

.DESCRIPTION
    This script queries all the computers in the specified Active Directory Organizational Unit (OU).
    For each computer, it retrieves the local user accounts and checks if they have administrator privileges.
    The results are displayed in the console and can be exported to a CSV file.

.PARAMETER OU
    The distinguished name (DN) of the Organizational Unit (OU) to query.
    For example: "OU=Workstations,DC=domain,DC=com"

.PARAMETER OutputFile
    (Optional) The file path where the results should be saved as a CSV file.

.PARAMETER VerboseLogging
    (Optional) Enables verbose output for logging the process.

.EXAMPLE
    .\Find-LocalUsers.ps1 -OU "OU=Workstations,DC=domain,DC=com"

    This example queries all computers in the "Workstations" OU in the "domain.com" domain and displays the local users and their admin status.

.EXAMPLE
    .\Find-LocalUsers.ps1 -OU "OU=Workstations,DC=domain,DC=com" -OutputFile "C:\results\LocalUsers.csv"

    This example queries all computers in the "Workstations" OU and saves the results to "LocalUsers.csv" in the C:\results folder.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$OU,  # OU in the format "OU=Workstations,DC=domain,DC=com"

    [Parameter(Mandatory=$false)]
    [string]$OutputFile,  # File path for CSV output

    [Parameter(Mandatory=$false)]
    [switch]$VerboseLogging
)

# Import Active Directory module if not already loaded
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Import-Module ActiveDirectory
}

function Get-LocalUsers {
    param (
        [string]$ComputerName
    )

    try {
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            $localUsers = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount=True"
            $localAdmins = Get-WmiObject -Class Win32_GroupUser | Where-Object {
                $_.GroupComponent -like '*"Administrators"*'
            }
            $localUsers | ForEach-Object {
                $user = $_
                $adminStatus = $false
                if ($localAdmins -match $user.Name) {
                    $adminStatus = $true
                }
                # Output only the relevant properties
                [pscustomobject]@{
                    ComputerName = $env:COMPUTERNAME
                    UserName     = $user.Name
                    AdminStatus  = $adminStatus
                }
            }
        } -HideComputerName
    } catch {
        Write-Error "Failed to query $ComputerName"
    }
}

# Query the DC for computers in the specified OU
try {
    Write-Host "Querying Active Directory for computers in OU: $OU..." -Verbose:$VerboseLogging
    $computers = Get-ADComputer -SearchBase $OU -Filter * | Select-Object -ExpandProperty Name
    Write-Host "Found $($computers.Count) computers in the specified OU." -Verbose:$VerboseLogging
} catch {
    Write-Error "Failed to query AD for computers in OU: $OU. Error: $_"
    return
}

# Initialize results array
$results = @()

# Loop through each computer and get local users
foreach ($computer in $computers) {
    Write-Host "Querying $computer for local accounts..." -Verbose:$VerboseLogging
    $results += Get-LocalUsers -ComputerName $computer
}

# Output the results to the console (with no extra columns)
$results | Select-Object ComputerName, UserName, AdminStatus | Format-Table -AutoSize

# Export the results to a CSV file if specified
if ($OutputFile) {
    try {
        Write-Host "Exporting results to $OutputFile..." -Verbose:$VerboseLogging
        $results | Select-Object ComputerName, UserName, AdminStatus | Export-Csv -Path $OutputFile -NoTypeInformation
        Write-Host "Export completed successfully." -ForegroundColor Green
    } catch {
        Write-Error "Failed to export results to $OutputFile. Error: $_"
    }
}



