
<#PSScriptInfo

.VERSION 1.0

.GUID e4b0c101-00f1-4e53-9204-6ea23120f37c

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
 Disables acount deligation as well as enables 128/256 bit Kerberos - AKA makes the account more secure. 

#> 
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the username of the AD user")]
    [string]$UserName
)

# Fetch the current user object with the relevant properties
$User = Get-ADUser -Identity $UserName -Properties AccountNotDelegated, msDS-SupportedEncryptionTypes

# Prepare a list to track changes made
$ChangesMade = @()

# Set "Account is sensitive and cannot be delegated" if it's not already true
if ($User.AccountNotDelegated -ne $true) {
    Set-ADUser -Identity $UserName -AccountNotDelegated $true
    $ChangesMade += "AccountNotDelegated: Changed from $($User.AccountNotDelegated) to True"
}

# Check the current Kerberos encryption settings and update them if necessary
$CurrentEncryptionTypes = $User.'msDS-SupportedEncryptionTypes'
$RequiredEncryptionTypes = 0x08 + 0x10  # 128-bit (0x08) + 256-bit (0x10)

if ($CurrentEncryptionTypes -ne $RequiredEncryptionTypes) {
    Set-ADUser -Identity $UserName -Replace @{ 'msDS-SupportedEncryptionTypes' = $RequiredEncryptionTypes }
    $ChangesMade += "msDS-SupportedEncryptionTypes: Changed from $CurrentEncryptionTypes to $RequiredEncryptionTypes (128-bit + 256-bit Kerberos)"
}

# Return a list of changes made
if ($ChangesMade.Count -eq 0) {
    Write-Host "No changes were necessary for $UserName."
} else {
    Write-Host "Changes made for ${$UserName}:"
    $ChangesMade | ForEach-Object { Write-Host $_ }
}


