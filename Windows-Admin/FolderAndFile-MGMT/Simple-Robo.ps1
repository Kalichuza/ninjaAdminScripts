[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$source,

    [Parameter(Mandatory = $true)]
    [string]$destination,

    [Parameter(Mandatory = $true)]
    [string]$logFilePath
)

# Determine if the source is a file or a directory
if (Test-Path -Path $source -PathType Leaf) {
    # Source is a file
    $sourceDir = Split-Path -Path $source
    $fileName = Split-Path -Path $source -Leaf

    Write-Host "Source detected as a file: $fileName in directory: $sourceDir" -ForegroundColor Green
    Write-Host "Preparing Robocopy for a single file..." -ForegroundColor Cyan

    robocopy "$sourceDir" "$destination" "$fileName" /ETA /R:3 /W:5 /TEE /LOG:"$logFilePath" /Z
} elseif (Test-Path -Path $source -PathType Container) {
    # Source is a directory
    Write-Host "Source detected as a directory: $source" -ForegroundColor Green
    Write-Host "Preparing Robocopy for directory copy..." -ForegroundColor Cyan

    robocopy "$source" "$destination" /E /ETA /R:3 /W:5 /TEE /LOG:"$logFilePath" /Z
} else {
    # Invalid source
    Write-Host "The specified source path does not exist or is invalid: $source" -ForegroundColor Red
    exit 1
}

Write-Host "Robocopy operation completed." -ForegroundColor Green
