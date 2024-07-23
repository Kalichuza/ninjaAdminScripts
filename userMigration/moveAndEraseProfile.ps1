# Set the username variable from an environment variable
#$folderName = $env:folderName

# Define the user folder path
$userFolderPath = "C:\Users\$folderName"

# Define a temporary empty directory path
$tempEmptyDir = "C:\TempEmptyDir"

# Function to create an empty directory
function Create-EmptyDirectory {
    param (
        [string]$path
    )
    if (Test-Path -Path $path) {
        Remove-Item -Path $path -Recurse -Force
    }
    New-Item -ItemType Directory -Path $path
}

# Function to remove the user folder
function Remove-UserFolder {
    param (
        [string]$path
    )
    try {
        # Create an empty directory
        Create-EmptyDirectory -path $tempEmptyDir

        # Mirror the empty directory to the target directory
        robocopy $tempEmptyDir $path /MIR

        # Remove the target directory itself
        Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
        Write-Host "Successfully deleted user folder: $path" -ForegroundColor Green
    } catch {
        Write-Host "Failed to delete user folder: $path. Error: $_" -ForegroundColor Red
        exit 1
    }
}

# Check if the user folder exists
if (Test-Path -Path $userFolderPath) {
    Write-Host "Deleting user folder: $userFolderPath" -ForegroundColor Yellow
    Remove-UserFolder -path $userFolderPath

    # Clean up the temporary empty directory
    if (Test-Path -Path $tempEmptyDir) {
        Remove-Item -Path $tempEmptyDir -Recurse -Force
    }
} else {
    Write-Host "User folder not found: $userFolderPath" -ForegroundColor Red
    exit 1
}
