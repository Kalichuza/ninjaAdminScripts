
<#PSScriptInfo

.VERSION 1.0

.GUID 438564b9-0d8a-45bb-9da8-c91bd90d0117

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
 Sets folder ACL based upon input parameters 

#> 

<#
.SYNOPSIS
    Script to add an ACL entry for a specified user to a folder with customizable permissions.

.DESCRIPTION
    This script allows the user to add an Access Control List (ACL) entry to a specified folder.
    The user can choose the type of access rights, the user or group to assign those rights, 
    and the folder path at runtime.

.PARAMETER FolderPath
    The path to the folder where the ACL entry should be added.

.PARAMETER IdentityReference
    The user or group to whom the ACL entry should be applied (e.g., "domain\username").

.PARAMETER AccessRights
    The type of access rights to assign. Valid options include:
    - FullControl
    - Modify
    - ReadAndExecute
    - Write
    - Read

.PARAMETER InheritanceFlags
    Specifies how the access rule is inherited by subfolders and files. Default is "ContainerInherit, ObjectInherit".

.PARAMETER PropagationFlags
    Specifies how the access rule is propagated to subfolders and files. Default is "None".

.EXAMPLE
    .\Set-FolderPermissions.ps1 -FolderPath "\\spdfs\Users\kjswart\Scans" -IdentityReference "saugertiesny\adminscanuser" -AccessRights Modify

    Adds a Modify access rule for the user "saugertiesny\adminscanuser" to the specified folder.

.EXAMPLE
    .\Set-FolderPermissions.ps1 -FolderPath "C:\Temp" -IdentityReference "BUILTIN\Users" -AccessRights Read -InheritanceFlags "ContainerInherit,ObjectInherit"

    Adds a Read access rule for the group "BUILTIN\Users" to the specified folder with inheritance.

.NOTES
    Author: Kalichuza
    Date: September 2024
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, HelpMessage="Enter the full path to the folder.")]
    [string]$FolderPath,

    [Parameter(Mandatory=$true, HelpMessage="Enter the user or group (e.g., domain\username).")]
    [string]$IdentityReference,

    [Parameter(Mandatory=$true, HelpMessage="Enter the type of access rights (e.g., FullControl, Modify, ReadAndExecute, Write, Read).")]
    [ValidateSet("FullControl", "Modify", "ReadAndExecute", "Write", "Read")]
    [string]$AccessRights,

    [Parameter(HelpMessage="Specify the inheritance flags (default is ContainerInherit, ObjectInherit).")]
    [ValidateSet("None", "ContainerInherit", "ObjectInherit", "ContainerInherit,ObjectInherit")]
    [string]$InheritanceFlags = "ContainerInherit,ObjectInherit",

    [Parameter(HelpMessage="Specify the propagation flags (default is None).")]
    [ValidateSet("None", "NoPropagateInherit", "InheritOnly")]
    [string]$PropagationFlags = "None"
)

# Convert InheritanceFlags and PropagationFlags to enum types
$inheritFlags = [System.Security.AccessControl.InheritanceFlags]::None
$propFlags = [System.Security.AccessControl.PropagationFlags]::None

switch ($InheritanceFlags) {
    "ContainerInherit" { $inheritFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit }
    "ObjectInherit" { $inheritFlags = [System.Security.AccessControl.InheritanceFlags]::ObjectInherit }
    "ContainerInherit,ObjectInherit" { $inheritFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit }
}

switch ($PropagationFlags) {
    "NoPropagateInherit" { $propFlags = [System.Security.AccessControl.PropagationFlags]::NoPropagateInherit }
    "InheritOnly" { $propFlags = [System.Security.AccessControl.PropagationFlags]::InheritOnly }
    "None" { $propFlags = [System.Security.AccessControl.PropagationFlags]::None }
}

# Get the current ACL for the folder
try {
    $acl = Get-Acl -Path $FolderPath
} catch {
    Write-Error "Failed to retrieve ACL for the path '$FolderPath'. Ensure the path is correct."
    exit 1
}

# Define the new access rule
try {
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        $IdentityReference, 
        $AccessRights, 
        $inheritFlags, 
        $propFlags, 
        [System.Security.AccessControl.AccessControlType]::Allow
    )
} catch {
    Write-Error "Failed to create the access rule. Check the provided parameters."
    exit 1
}

# Add the new access rule to the ACL
try {
    $acl.AddAccessRule($accessRule)
} catch {
    Write-Error "Failed to add the access rule to the ACL."
    exit 1
}

# Set the updated ACL back to the folder
try {
    Set-Acl -Path $FolderPath -AclObject $acl
    Write-Output "Successfully added the access rule for $IdentityReference with $AccessRights rights to $FolderPath."
} catch {
    Write-Error "Failed to set the updated ACL for the folder '$FolderPath'."
    exit 1
}



