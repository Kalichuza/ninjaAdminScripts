
<#PSScriptInfo

.VERSION 1.2

.GUID 2a41411d-466a-42ba-817f-f9aa86be0a7a

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
 Disbles deligation for the chosen computer. Mainly intended for domain controllers, but can used on any AD computer object 

#> 
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$ComputerName
)

# Get the computer account before the change
$BeforeChange = Get-ADComputer -Identity $ComputerName -Properties TrustedForDelegation

# Check if the computer account is currently trusted for delegation
if ($BeforeChange.TrustedForDelegation -eq $true) {
    Write-Host "Computer account is currently trusted for delegation. Making changes..."

    # Modify the account to "Do not trust for delegation"
    Set-ADComputer -Identity $ComputerName -TrustedForDelegation $false

    # Get the computer account after the change
    $AfterChange = Get-ADComputer -Identity $ComputerName -Properties TrustedForDelegation

    # Compare and display the changes
    if ($BeforeChange.TrustedForDelegation -ne $AfterChange.TrustedForDelegation) {
        Write-Host "`nProperty: 'TrustedForDelegation'"
        Write-Host "  Before: '$($BeforeChange.TrustedForDelegation)'"
        Write-Host "  After:  '$($AfterChange.TrustedForDelegation)'"
    } else {
        Write-Host "No changes were made to 'TrustedForDelegation'."
    }
} else {
    Write-Host "The computer account is already set to 'Do not trust for delegation'. No changes needed."
}
