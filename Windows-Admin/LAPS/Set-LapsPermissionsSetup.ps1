
<#PSScriptInfo

.VERSION 1.0

.GUID 213e6231-cf66-4d6a-a61c-39360cea6037

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
 Sets the proper permissions for proper LAPS operations. 

#> 



<#
.SYNOPSIS
    Automates the configuration of permissions for computers to update their own passwords and grants necessary permissions for IT admins.

.DESCRIPTION
    This script automates the following tasks:
    1. Set self-permission for computers to update their own `ms-Mcs-AdmPwd` and `ms-Mcs-AdmPwdExpirationTime` attributes.
    2. Grant read permission to specified users or groups for the `ms-Mcs-AdmPwd` attribute.
    3. Grant reset permission for the local administrator passwords to specified users or groups.

.PARAMETER OrgUnit
    The distinguished name (DN) of the target Organizational Unit (OU) where the permissions will be applied.
    Example: "OU=ManagedComputers,DC=domain,DC=local"

.PARAMETER AllowedPrincipals
    The security groups or users to whom the read and reset permissions will be granted.
    Example: "Domain Admins"

.EXAMPLEfind
    Set-LapsPermissions -OrgUnit "OU=ManagedComputers,DC=domain,DC=local" -AllowedPrincipals "Domain Admins"

.NOTES
    Author: Your Name
    Date: YYYY-MM-DD
    Version: 1.0.0
    License: GNU General Public License v3.0
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "The distinguished name (DN) of the target Organizational Unit (OU).")]
    [string]$OrgUnit,

    [Parameter(Mandatory = $true, HelpMessage = "The security groups or users to whom the permissions will be granted.")]
    [string]$AllowedPrincipals
)

# Set self-permission for computers to update their own passwords
Write-Host "Setting self-permission for computers to update their own passwords..."
try {
    Set-AdmPwdComputerSelfPermission -OrgUnit $OrgUnit
    Write-Host "Self-permission set successfully."
} catch {
    Write-Error "Failed to set self-permission: $_"
    exit 1
}

# Grant read permission to IT admins for password retrieval
Write-Host "Granting read permission for password retrieval to $AllowedPrincipals..."
try {
    Set-AdmPwdReadPasswordPermission -OrgUnit $OrgUnit -AllowedPrincipals $AllowedPrincipals
    Write-Host "Read permission granted successfully."
} catch {
    Write-Error "Failed to grant read permission: $_"
    exit 1
}

# Grant reset permission for local administrator passwords
Write-Host "Granting reset permission for local administrator passwords to $AllowedPrincipals..."
try {
    Set-AdmPwdResetPasswordPermission -OrgUnit $OrgUnit -AllowedPrincipals $AllowedPrincipals
    Write-Host "Reset permission granted successfully."
} catch {
    Write-Error "Failed to grant reset permission: $_"
    exit 1
}

Write-Host "All tasks completed successfully."
