<#PSScriptInfo

.VERSION 1.1

.GUID 3c785644-3df9-410d-998e-b32d8a504bdb

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
 A simple script that leverages ROBOCOPY to move files and folders, while giving an ongoing status. 

#> 
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$source,

    [Parameter(Mandatory = $true)]
    [string]$destination,

    [Parameter(Mandatory = $false)]
    [string]$logFilePath
)

# Determine if the source is a file or a directory
if (Test-Path -Path $source -PathType Leaf) {
    # Source is a file
    $sourceDir = Split-Path -Path $source
    $fileName = Split-Path -Path $source -Leaf

    Write-Host "Source detected as a file: $fileName in directory: $sourceDir" -ForegroundColor Green
    Write-Host "Preparing Robocopy for a single file..." -ForegroundColor Cyan

    # Build robocopy arguments
    $robocopyArgs = @("$sourceDir", "$destination", "$fileName", "/ETA", "/R:3", "/W:5", "/TEE", "/Z")
    if ($logFilePath) {
        $robocopyArgs += "/LOG:`"$logFilePath`""
    }

    robocopy @robocopyArgs

} elseif (Test-Path -Path $source -PathType Container) {
    # Source is a directory
    Write-Host "Source detected as a directory: $source" -ForegroundColor Green
    Write-Host "Preparing Robocopy for directory copy..." -ForegroundColor Cyan

    # Build robocopy arguments
    $robocopyArgs = @("$source", "$destination", "/E", "/ETA", "/R:3", "/W:5", "/TEE", "/Z")
    if ($logFilePath) {
        $robocopyArgs += "/LOG:`"$logFilePath`""
    }

    robocopy @robocopyArgs

} else {
    # Invalid source
    Write-Host "The specified source path does not exist or is invalid: $source" -ForegroundColor Red
    exit 1
}

Write-Host "Robocopy operation completed." -ForegroundColor Green
