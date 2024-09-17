<#PSScriptInfo

.VERSION 1.0.2

.GUID bc3eea3c-c0a7-4914-be96-5d805806109d

.AUTHOR Kalichuza

#>

<# 

.DESCRIPTION 
 Copies ENTIRE User\UserProfile to another folder. 

#> 

<#
.SYNOPSIS
Copies the contents of a user profile folder from a source location to a destination using Robocopy.

.PARAMETER source
The full path to the source directory that needs to be copied. This parameter is required.

.PARAMETER destination
The full path to the destination directory where the source files and directories will be copied. This parameter is required. If the destination does not exist, the script will create it.

.PARAMETER username
The username that may be required for accessing network shares or secure locations. This parameter is optional.

.PARAMETER password
A secure password associated with the username. If the username is provided, the script will prompt for the password securely.

.EXAMPLE
.\Copy-UserProfileAll.ps1 -source "C:\Users\Profile" -destination "D:\Backup\Profile" -username "myUser"

This command copies the entire contents of `C:\Users\Profile` to `D:\Backup\Profile`. It will prompt for the password if the username is provided.
#>

param (
    [string]$source,
    [string]$destination,
    [string]$username
)

# Ensure the source and destination are provided
if (-not $source -or -not $destination) {
    Write-Host "Usage: .\Copy-UserProfileAll.ps1 -source <source> -destination <destination> [-username <username>]"
    exit 1
}

# Prompt for password if username is provided
$credential = $null
if ($username) {
    $password = Read-Host -AsSecureString "Enter password for $username"
    $credential = New-Object System.Management.Automation.PSCredential($username, $password)
}

# Define the full paths for the source and destination
$sourcePath = $source
$destinationPath = $destination

# Check if the source directory exists
if (-not (Test-Path -Path $sourcePath)) {
    Write-Host "Source path does not exist: $sourcePath"
    exit 1
}

# Create the destination directory if it does not exist
if (-not (Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath -Force
}

# Execute robocopy command to copy the source to the destination
robocopy $sourcePath $destinationPath /MIR /COPYALL /R:0 /W:0 /MT:8 /ETA /V /TEE /XJ

# Check robocopy exit code
$robocopyExitCode = $LASTEXITCODE

if ($robocopyExitCode -le 7) {
    Write-Host "Source copied successfully from $sourcePath to $destinationPath."
} else {
    Write-Host "Error copying source. Robocopy exit code: $robocopyExitCode"
}
