<#
.SYNOPSIS
    Automates the process of provisioning an SMB share on a Windows Server.

.DESCRIPTION
    This script creates a directory (if it does not already exist), sets NTFS permissions for the specified user or group, 
    and creates an SMB share with the given name and access rights.

.PARAMETER ShareName
    The name of the SMB share to be created.

.PARAMETER SharePath
    The full file system path to the directory that will be shared. If the directory does not exist, it will be created.

.PARAMETER GroupOrUser
    The domain group or user that will be granted access to the SMB share.

.PARAMETER AccessRight
    The level of access to be granted to the specified group or user. 
    Valid values are 'FullControl', 'Modify', 'ReadAndExecute', 'Read', and 'Write'. 
    The default is 'FullControl'.

.EXAMPLE
    .\Provision-SmbShare.ps1 -ShareName "DEV" -SharePath "C:\DEV" -GroupOrUser "Domain Admins" -AccessRight "FullControl" -Verbose

    This command creates an SMB share named 'DEV' at the path 'C:\DEV' with full control granted to the 'Domain Admins' group.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$ShareName,

    [Parameter(Mandatory = $true)]
    [string]$SharePath,

    [Parameter(Mandatory = $true)]
    [string]$GroupOrUser,

    [Parameter(Mandatory = $false)]
    [ValidateSet('FullControl', 'Modify', 'ReadAndExecute', 'Read', 'Write')]
    [string]$AccessRight = 'FullControl'
)

# Ensure the directory exists
Write-Verbose "Creating directory if it does not exist..."
if (-not (Test-Path -Path $SharePath)) {
    New-Item -Path $SharePath -ItemType Directory | Out-Null
}

# Get the current ACL for the directory
$acl = Get-Acl -Path $SharePath

# Create a file system access rule
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule($GroupOrUser, $AccessRight, "ContainerInherit,ObjectInherit", "None", "Allow")

# Apply the ACL to the directory
$acl.SetAccessRule($rule)
Set-Acl -Path $SharePath -AclObject $acl

# Create the SMB Share
Write-Verbose "Creating SMB share..."
New-SmbShare -Name $ShareName -Path $SharePath -FullAccess $GroupOrUser

Write-Output "SMB share '$ShareName' successfully created at path '$SharePath'."
