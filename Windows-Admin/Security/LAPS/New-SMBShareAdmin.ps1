
<#PSScriptInfo

.VERSION 1.1

.GUID 511303d2-f65c-4f41-891c-1a54503d142a

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
 Creates an SMB share that has sets Administrators as the owner with full rights 

#> 

<#
.SYNOPSIS
    Creates a new SMB share and grants access only to the Administrators group.

.DESCRIPTION
    This script creates a new SMB share at the specified path, and grants full control permissions only to the Administrators group. 
    All other access is removed.

.PARAMETER SharePath
    The local path to the folder that will be shared. If the folder does not exist, it will be created.

.PARAMETER ShareName
    The name of the new SMB share.

.EXAMPLE
    .\New-SMBShareAdmin.ps1 -SharePath "C:\PWSH" -ShareName "pwsh"

    This example creates a new SMB share named "pwsh" at "C:\PWSH" with access restricted to the Administrators group.

.NOTES

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, HelpMessage = "The local path to the folder that will be shared.")]
    [string]$SharePath,

    [Parameter(Mandatory = $true, HelpMessage = "The name of the new SMB share.")]
    [string]$ShareName
)

# Create the directory if it doesn't exist
if (-Not (Test-Path -Path $SharePath)) {
    New-Item -ItemType Directory -Path $SharePath -Force
}

# Remove existing SMB share with the same name if it exists
if (Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue) {
    Remove-SmbShare -Name $ShareName -Force
}

# Create the SMB share and restrict access to the Administrators group only
New-SmbShare -Name $ShareName -Path $SharePath -FullAccess "Administrators"

# Set the NTFS permissions for the folder to grant full control to the Administrators group only
$acl = Get-Acl $SharePath

# Remove all existing permissions
$acl.SetAccessRuleProtection($true, $false)
$acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }

# Add the Administrators group with FullControl
$adminAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($adminAccessRule)

Set-Acl $SharePath $acl

Write-Host "SMB share '$ShareName' created at '$SharePath' with full control granted to the Administrators group only."
