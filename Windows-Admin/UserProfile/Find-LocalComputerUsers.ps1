
<#PSScriptInfo

.VERSION 1.0.0

.GUID f0ce286d-ee36-47e8-8508-f5d3591c120c

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
 Finds local users and their permissions. 

#> 
<#
.SYNOPSIS
    Queries the local machine for active local accounts and their administrator status.

.DESCRIPTION
    This script queries the local machine for local user accounts and checks if they have administrator privileges.
    The results are displayed in the console and can be exported to a CSV file.

.PARAMETER OutputFile
    (Optional) The file path where the results should be saved as a CSV file.

.PARAMETER VerboseLogging
    (Optional) Enables verbose output for logging the process.

.EXAMPLE
    .\Find-LocalUsersLocal.ps1

    This example queries the local machine for local users and their admin status and displays the results in the console.

.EXAMPLE
    .\Find-LocalUsersLocal.ps1 -OutputFile "C:\results\LocalUsers.csv"

    This example queries the local machine for local users and saves the results to "LocalUsers.csv" in the C:\results folder.
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$OutputFile,  # File path for CSV output

    [Parameter(Mandatory=$false)]
    [switch]$VerboseLogging
)

function Get-LocalUsers {
    try {
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
    } catch {
        Write-Error "Failed to query local accounts. Error: $_"
    }
}

# Initialize results array
$results = Get-LocalUsers

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



