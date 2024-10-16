
<#PSScriptInfo

.VERSION 1.0

.GUID 7ca55805-031c-4d6b-87a5-60136e4ea644

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
 Returns the object permissions for the DC 

#> 
<#
.SYNOPSIS
    Retrieves the Access Control List (ACL) for a specified domain controller in Active Directory and outputs it as objects.

.DESCRIPTION
    This script retrieves and displays all the ACL entries for a specified domain controller object in Active Directory.
    The output is in the form of PowerShell objects, allowing for easy filtering and piping to other commands.

.PARAMETER Domain
    The domain name where the domain controller is located.

.PARAMETER DC
    The name of the domain controller for which the ACL should be retrieved.

.EXAMPLE
    Get-DcGenericAll.ps1 -Domain "DomainName.local" -DC "YourDC" | Where-Object { $_.ActiveDirectoryRights -eq "GenericAll" }
    Retrieves and filters the ACL entries for the domain controller in the DomainName.local domain, showing only entries with GenericAll rights.

#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Domain,

    [Parameter(Mandatory = $true)]
    [string]$DC
)

# Construct the distinguished name of the domain controller object
$dcDistinguishedName = "CN=$DC,OU=Domain Controllers,DC=" + $Domain.Replace('.', ',DC=')

# Retrieve the ACL for the specified domain controller object
$acl = Get-ACL "AD:\$dcDistinguishedName"

# Convert ACL entries to objects and output them
$acl.Access | ForEach-Object {
    [PSCustomObject]@{
        IdentityReference      = $_.IdentityReference
        ActiveDirectoryRights  = $_.ActiveDirectoryRights
        InheritanceFlags       = $_.InheritanceFlags
        ObjectType             = $_.ObjectType
        AccessControlType      = $_.AccessControlType
    }
}


