
<#PSScriptInfo

.VERSION 1.0.0

.GUID bc3eea3c-c0a7-4914-be96-5d805806109d

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
 Copies ENTIRE User\UserProfile to another folder. 

#> 

<#
.SYNOPSIS
Copies the contents of a folder from a source location to a destination using Robocopy.

.DESCRIPTION
This script uses Robocopy to mirror a folder from a source path to a destination path, ensuring all contents, including subdirectories and files, are copied. Robocopy is a powerful command-line utility that provides numerous options for file copying, mirroring, and synchronization, making it a reliable tool for this purpose. The script supports the use of multithreading (`/MT:8`), and displays detailed progress information while copying. It can also handle directory creation if the destination does not exist.

.PARAMETER source
The full path to the source directory that needs to be copied. This parameter is required.

.PARAMETER destination
The full path to the destination directory where the source files and directories will be copied. This parameter is required. If the destination does not exist, the script will create it.

.PARAMETER username
The username that may be required for accessing network shares or secure locations. This parameter is required but currently not used in the Robocopy command directly. (Placeholder for future use.)

.PARAMETER password
The password associated with the username, if required for access to the source or destination. This parameter is required but currently not used in the Robocopy command directly. (Placeholder for future use.)

.EXAMPLE
.\copyFolder.ps1 -source "C:\Data\Projects" -destination "D:\Backup\Projects" -username "myUser" -password "myPassword"

This command copies the contents of `C:\Data\Projects` to `D:\Backup\Projects`. The username and password parameters are placeholders in this version and are not used directly.

.NOTES
- This script checks for the existence of both the source and destination directories.
- If the source directory does not exist, the script will exit with an error.
- If the destination directory does not exist, the script will create it before copying the files.
- Robocopy will mirror the directory structure and files from the source to the destination.
- The Robocopy exit code is checked to determine the success of the operation, with exit codes `0-7` indicating success.

.ROBUSTNESS
- The script is designed to handle both local and network file systems, but username/password functionality is not currently implemented for network shares.

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
    Write-Host "Usage: .\copyFolder.ps1 -source <source> -destination <destination> -username <username> -password <password>"
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

# Execute robocopy command to copy the source to the destination
robocopy $sourcePath $destinationPath /MIR /COPYALL /R:0 /W:0 /MT:8 /ETA /V /TEE /XJ

# Check robocopy exit code
$robocopyExitCode = $LASTEXITCODE

if ($robocopyExitCode -le 7) {
    Write-Host "Source copied successfully from $sourcePath to $destinationPath."
} else {
    Write-Host "Error copying source. Robocopy exit code: $robocopyExitCode"
}



