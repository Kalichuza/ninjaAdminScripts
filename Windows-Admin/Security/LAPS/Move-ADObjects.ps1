<#PSScriptInfo

.VERSION 1.2

.GUID 63ecb037-8d14-4007-869e-71882d320728

.AUTHOR Kalichuza

#>

<# 

.DESCRIPTION 
 Moves Active Directory computer objects from one OU to another based on a search filter.

#>

param (
    [Parameter(Mandatory=$true)]
    [string]$domainName,   # Example: "YourDomain"
    
    [Parameter(Mandatory=$true)]
    [string]$searchBaseOU, # Example: "CN=Computers"
    
    [Parameter(Mandatory=$true)]
    [string]$targetOU      # Example: "OU=ManagedComputers"
)

# Build the distinguished names dynamically based on the provided domain
$searchBaseDN = "$searchBaseOU,DC=$domainName,DC=local"
$targetPathDN = "$targetOU,DC=$domainName,DC=local"

# Fetch and move the computers
Get-ADComputer -SearchBase $searchBaseDN -Filter * | ForEach-Object {
    Move-ADObject -Identity $_.DistinguishedName -TargetPath $targetPathDN
}
