<#
.SYNOPSIS
    Script to query the distinguished name (DN) of an Organizational Unit (OU).

.DESCRIPTION
    This script queries the distinguished name (DN) of an Organizational Unit (OU) in Active Directory.

.PARAMETER OUName
    The name of the Organizational Unit (OU) to query.

.EXAMPLE
    .\Query-OU.ps1 -OUName "Disabled Accounts"

.NOTES
    Author: Your Name
    Date: 2024-07-31
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$OUName
)

# Import the Active Directory module
Import-Module ActiveDirectory

try {
    # Query the OU
    $ou = Get-ADOrganizationalUnit -Filter "Name -eq '$OUName'"
    
    # Check if the OU was found
    if ($ou) {
        Write-Output "Distinguished Name: $($ou.DistinguishedName)"
    } else {
        Write-Output "Organizational Unit '$OUName' not found."
    }
} catch {
    Write-Output "An error occurred: $_"
}
