<#
.SYNOPSIS
    Script to create a new Active Directory user.

.DESCRIPTION
    This script creates a new Active Directory user with the specified details.

.PARAMETER Name
    The full name of the user.

.PARAMETER GivenName
    The given name (first name) of the user.

.PARAMETER Surname
    The surname (last name) of the user.

.PARAMETER SamAccountName
    The SAM account name (username) of the user.

.PARAMETER UserPrincipalName
    The User Principal Name (UPN) of the user.

.PARAMETER Path
    The organizational unit (OU) where the user will be created.

.PARAMETER AccountPassword
    The password for the user account.

.PARAMETER Enabled
    Indicates whether the user account is enabled.

.PARAMETER ChangePasswordAtLogon
    Indicates whether the user must change the password at the next logon.

.PARAMETER Description
    The description for the user account.

.PARAMETER Organization
    The organization name for the user account.

.EXAMPLE
    .\Create-ADUser.ps1 -Name "John Doe" -GivenName "John" -Surname "Doe" -SamAccountName "jdoe" `
    -UserPrincipalName "jdoe@example.com" -Path "OU=Users,DC=example,DC=com" `
    -AccountPassword (ConvertTo-SecureString "P@ssw0rd123" -AsPlainText -Force) -Enabled $true `
    -ChangePasswordAtLogon $true -Description "MCS" -Organization "MCS"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Name,

    [Parameter(Mandatory=$true)]
    [string]$GivenName,

    [Parameter(Mandatory=$true)]
    [string]$Surname,

    [Parameter(Mandatory=$true)]
    [string]$SamAccountName,

    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName,

    [Parameter(Mandatory=$true)]
    [string]$Path,

    [Parameter(Mandatory=$true)]
    [SecureString]$AccountPassword,

    [Parameter(Mandatory=$true)]
    [bool]$Enabled,

    [Parameter(Mandatory=$true)]
    [bool]$ChangePasswordAtLogon,

    [Parameter(Mandatory=$true)]
    [string]$Description,

    [Parameter(Mandatory=$true)]
    [string]$Organization
)

New-ADUser `
    -Name $Name `
    -GivenName $GivenName `
    -Surname $Surname `
    -SamAccountName $SamAccountName `
    -UserPrincipalName $UserPrincipalName `
    -Path $Path `
    -AccountPassword $AccountPassword `
    -Enabled $Enabled `
    -ChangePasswordAtLogon $ChangePasswordAtLogon `
    -Description $Description `
    -Organization $Organization
