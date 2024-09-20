
<#PSScriptInfo

.VERSION 1.0.0

.GUID cd8aec00-3dd2-4f2e-8bd2-9004bc893591

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
 Lists AD computers by last logondate  

#> 
# Import Active Directory module
Import-Module ActiveDirectory

# Get all computers in the domain
$computers = Get-ADComputer -Filter * -Property Name, LastLogonDate, LastLogonTimestamp | ForEach-Object {
    # Get the last logon time from LastLogonTimestamp
    $lastLogonTime = [DateTime]::FromFileTime($_.LastLogonTimestamp)
    [PSCustomObject]@{
        ComputerName = $_.Name
        LastLogon    = $lastLogonTime
    }
}

# Sort by LastLogon in descending order and display the results
$computers | Sort-Object LastLogon -Descending | Format-Table -AutoSize



