param (

    [string]$source,

    [string]$destination

)


# Ensure the source and destination paths are provided

if (-not $source -or -not $destination) {

    Write-Host "Usage: .\moveFolder.ps1 -s <source> -d <destination>"

    exit 1

}


# Define the full paths for the source and destination

$sourcePath = "$source"

$destinationPath = "$destination"


# Check if the source directory exists

if (-not (Test-Path -Path $sourcePath)) {

    Write-Host "Source path does not exist: $sourcePath"

    exit 1

}


# Create the destination directory if it does not exist

if (-not (Test-Path -Path $destinationPath)) {

    New-Item -ItemType Directory -Path $destinationPath

}


# Execute robocopy command to copy the user profile

robocopy $sourcePath $destinationPath /MIR /COPYALL /R:0 /W:0 /MT:8 /ETA /V /TEE /XJ


# Check robocopy exit code

$robocopyExitCode = $LASTEXITCODE

if ($robocopyExitCode -le 7) {

    Write-Host "Source copied successfully from $sourcePath to $destinationPath."

} else {

    Write-Host "Error copying source. Robocopy exit code: $robocopyExitCode"

}

