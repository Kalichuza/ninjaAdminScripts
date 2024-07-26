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

# Execute robocopy command to move the source to the destination
robocopy $sourcePath $destinationPath /MIR /COPYALL /R:0 /W:0 /MT:8 /ETA /V /TEE /XJ /MOVE

# Check robocopy exit code
$robocopyExitCode = $LASTEXITCODE

if ($robocopyExitCode -le 7) {
    Write-Host "Source moved successfully from $sourcePath to $destinationPath."
} else {
    Write-Host "Error moving source. Robocopy exit code: $robocopyExitCode"
}
