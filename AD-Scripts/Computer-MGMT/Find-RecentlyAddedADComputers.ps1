
<#PSScriptInfo

.VERSION 1.0

.GUID 579e20fd-0e19-4789-880a-34dfe0dea331

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
 A simple script that queries AD for computers added to the domain in a selected time frame 

#> 
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$DaysAgo,

    [Parameter(Mandatory=$false)]
    [string]$OutputFile
)
#set out the start date


# Check if the Active Directory module is installed
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Host "Active Directory module not found. Installing..." -ForegroundColor Yellow
    Install-WindowsFeature -Name RSAT-AD-PowerShell
}

# Import the Active Directory module
Import-Module ActiveDirectory

$CutoffDate = (Get-Date).AddDays(-$DaysAgo)

# Get all computers from AD who were added within the specified timeframe
$computers = Get-ADComputer -Filter { whenCreated -gt $CutoffDate } -Properties whenCreated

Write-Host "Found $($computers.Count) computers added within the last $DaysAgo days" -ForegroundColor Green

# Output the results to the console (with no extra columns)
$computers | Select-Object Name, whenCreated | Format-Table -AutoSize

# Export the results to a CSV file if specified
if ($OutputFile) {
    $computers | Select-Object Name, whenCreated | Export-Csv -Path $OutputFile -NoTypeInformation
}
p


