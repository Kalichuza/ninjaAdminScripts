
<#PSScriptInfo

.VERSION 1.0

.GUID 1faf3ff1-1702-45f3-8afe-af54f4df4497

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


#>

<# 

.DESCRIPTION 
 Takes a file path argument to add a file to the system path. Thus, allowing it the be run from any Dir in the terminal. 

#> 


<#
.SYNOPSIS
    Adds a specified directory to the system's PATH environment variable.

.DESCRIPTION
    This script takes a user-specified directory path and adds it to the system's PATH environment variable.
    It supports adding paths for either the current user or the entire machine.

.PARAMETER Path
    The directory path to be added to the system's PATH variable.

.PARAMETER User
    If specified, the path will be added to the user's PATH variable instead of the machine's PATH variable.

.EXAMPLE
    .\Add-ToSystemPath.ps1 -Path "C:\Tools\fping"

    Adds the directory 'C:\Tools\fping' to the machine-wide PATH variable.

.EXAMPLE
    .\Add-ToSystemPath.ps1 -Path "C:\Tools\fping" -User

    Adds the directory 'C:\Tools\fping' to the current user's PATH variable.

.NOTES
    Author: kalichuza
    Date: October 7, 2024
    Version: 1.0

#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Enter the path you want to add to the PATH environment variable.")]
    [string]$Path,

    [Parameter(Mandatory = $false, HelpMessage = "Specify if you want to add the path for the current user instead of the machine.")]
    [switch]$User
)

# Determine the target for the environment variable
$target = if ($User) { 'User' } else { 'Machine' }

# Add the specified path to the PATH environment variable
try {
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", $target)
    if (-not ($currentPath -like "*$Path*")) {
        [System.Environment]::SetEnvironmentVariable("Path", "$currentPath;$Path", $target)
        Write-Host "Successfully added '$Path' to the $target PATH."
    }
    else {
        Write-Host "The path '$Path' is already present in the $target PATH."
    }
}
catch {
    Write-Error "An error occurred while trying to add the path: $_"
}

