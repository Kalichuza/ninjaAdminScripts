
<#PSScriptInfo

.VERSION 1.0.0

.GUID 2d2b504a-1ead-4dbb-b6ce-31f4a75ac61f

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
 Copies SAFE User\UserProfile Data to another folder.This will only copy the non system and hidden files. Use this if you think the origin profile has been corrupted for some reason. 

#> 

<#
.SYNOPSIS
Transfers specific user profile folders from a local directory to a mapped network drive using Robocopy.

.DESCRIPTION
This script copies user profile folders such as Documents, Desktop, Downloads, Favorites, and others from a source path to a destination path using Robocopy. Before running the script, the destination must be mapped as a network drive. The script iterates over a list of common user folders, copying each one from the source to the destination, and provides progress and error reporting for each folder.

.PARAMETER source
The full path to the source directory containing the user profile folders. This is typically a local directory where the data to be transferred is stored. This parameter is required.

.PARAMETER destination
The path to the destination, which is expected to be a mapped network drive. You must map the drive before running the script. The script will copy files to the mapped drive. This parameter is required.

.PARAMETER username
The username required for authentication to the network drive, typically in the format `domain\username`. This parameter is required but not directly used in this version of the script. (Placeholder for future use.)

.PARAMETER password
The password associated with the `username` for network drive access. This parameter is required but not directly used in this version of the script. (Placeholder for future use.)

.EXAMPLE
# Step 1: Map the network drive:
net use J: \\SERVER\Path\To\NetDrive /user:domain\administrator P4ssWord

# Step 2: Run the script:
.\moveFolder2NetDrive.ps1 -source "C:\Users\Profile" -destination "J:" -username "domain\administrator" -password 'P4ssWord'

This example maps the network drive `J:` to a shared folder on a server and then transfers specific profile folders (Documents, Desktop, etc.) from the local user profile directory to the network drive.

.NOTES
- This script is designed to handle the transfer of user profile directories such as Documents, Desktop, Downloads, and more.
- If the destination directory does not exist, the script will create it before copying.
- Robocopy will mirror the directory structure from the source to the destination, copying all files and subdirectories.
- The script checks for Robocopy exit codes and reports success or errors for each folder copied.

.ROBUSTNESS
- The username and password parameters are placeholders for future enhancements to handle network drive authentication within the script.

.REQUIREMENTS
- A mapped network drive must be set up before running the script.
- Robocopy must be installed and available on the system (it is included in most versions of Windows).

.HELP
For more information on Robocopy exit codes, refer to:
https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy
#>

param (
    [string]$source,
    [string]$destination,
    [string]$username,
    [string]$password
)

# Ensure the source, destination, username, and password are provided
if (-not $source -or -not $destination -or -not $username -or -not $password) {
    Write-Host "Usage: .\moveFolder.ps1 -source <source> -destination <destination> -username <username> -password <password>"
    exit 1
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

# Build the robocopy command
foreach ($dir in $includeDirs) {
    $sourceDir = Join-Path -Path $sourcePath -ChildPath $dir
    $destinationDir = Join-Path -Path $destinationPath -ChildPath $dir

    if (Test-Path -Path $sourceDir) {
        $robocopyCommand = "robocopy `"$sourceDir`" `"$destinationDir`" /MIR /COPYALL /R:0 /W:0 /MT:8 /ETA /V /TEE /XJ"
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



