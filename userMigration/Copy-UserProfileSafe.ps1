<#PSScriptInfo

.VERSION 1.0.2

.GUID 2d2b504a-1ead-4dbb-b6ce-31f4a75ac61f

.AUTHOR Kalichuza

#>

<# 

.DESCRIPTION 
 Copies SAFE User\UserProfile Data to another folder. This will only copy the non-system and non-hidden files. Use this if you think the origin profile has been corrupted for some reason. 

#> 

<#
.SYNOPSIS
Transfers specific user profile folders from a source path to a destination using Robocopy, excluding system and hidden files.

.PARAMETER source
The full path to the source directory containing the user profile folders. This is typically a local directory where the data to be transferred is stored. This parameter is required.

.PARAMETER destination
The path to the destination directory where the profile will be copied. The destination will be created if it does not exist.

.PARAMETER username
The username required for authentication to the destination, typically in the format `domain\username`. This parameter is optional.

.PARAMETER password
A secure password associated with the username. If the username is provided, the script will prompt for the password securely.

.EXAMPLE
.\Copy-UserProfileSafe.ps1 -source "C:\Users\Profile" -destination "D:\Backup\Profile" -username "domain\admin"

This example copies the safe profile data from `C:\Users\Profile` to `D:\Backup\Profile`, and will prompt for a password if a username is provided.
#>

param (
    [string]$source,
    [string]$destination,
    [string]$username
)

# Ensure the source and destination are provided
if (-not $source -or -not $destination) {
    Write-Host "Usage: .\Copy-UserProfileSafe.ps1 -source <source> -destination <destination> [-username <username>]"
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

# Define directories to include
$includeDirs = @("Documents", "Desktop", "Downloads", "Favorites", "Links", "Music", "Pictures", "Videos")

# Build the robocopy command for each directory
foreach ($dir in $includeDirs) {
    $sourceDir = Join-Path -Path $sourcePath -ChildPath $dir
    $destinationDir = Join-Path -Path $destinationPath -ChildPath $dir

    if (Test-Path -Path $sourceDir) {
        $robocopyCommand = "robocopy `"$sourceDir`" `"$destinationDir`" /MIR /COPYALL /R:0 /W:0 /MT:8 /ETA /V /TEE /XJ /A-:SH"
        Invoke-Expression $robocopyCommand

        # Check robocopy exit code
        $robocopyExitCode = $LASTEXITCODE

        if ($robocopyExitCode -le 7) {
            Write-Host "Copied $dir successfully from $sourceDir to $destinationDir."
        } else {
            Write-Host "Error copying $dir. Robocopy exit code: $robocopyExitCode"
        }
    } else {
        Write-Host "Source directory does not exist: $sourceDir"
    }
}

Write-Host "Profile data transfer completed."
