[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Enter the SamAccountName or DistinguishedName of the user.")]
    [Alias("sAMAccountName", "DN")]
    [string]$UserName,

    [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, HelpMessage="Enter the new email address to set for the user.")]
    [Alias("Email")]
    [string]$NewEmailAddress
)

function Get-Help {
    <#
    .SYNOPSIS
    Sets or updates the email address of a user in Active Directory.

    .DESCRIPTION
    This script sets or updates the email address of a user specified by their UserName in Active Directory.

    .PARAMETER UserName
    The SamAccountName or DistinguishedName of the user to update.

    .PARAMETER NewEmailAddress
    The new email address to set for the user.

    .EXAMPLE
    PS C:\> .\Set-ADUserEmail.ps1 -UserName "jdoe" -NewEmailAddress "jdoe@example.com"
    
    Sets the email address for the user "jdoe" to "jdoe@example.com".

    .NOTES
    Author: Your Name
    Date: 2024-08-06
    #>
}

Import-Module ActiveDirectory

try {
    Set-ADUser -Identity $UserName -EmailAddress $NewEmailAddress
    Write-Host "Successfully updated email address for user $UserName to $NewEmailAddress"
} catch {
    Write-Host "An error occurred: $_"
}
