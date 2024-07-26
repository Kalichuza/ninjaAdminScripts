Certainly! Here’s how you can combine all these instructions into one cohesive set of instructions for your script. This will be suitable for a README.md file for your GitHub project.

```markdown
# User Folder Cleanup and Profile Transfer Script

This PowerShell script is designed to delete a user's folder from the system and transfer the folder to a network drive.

## Prerequisites

- Ensure PowerShell is installed on your target machine.
- Make sure you have the necessary permissions to delete user folders and create network drives.

## Script Overview

### 1. Set the username variable from an environment variable

```powershell
$folderName = $env:folderName
```

### 2. Define the user folder path

```powershell
$userFolderPath = "C:\Users\$folderName"
```

### 3. Define a temporary empty directory path

```powershell
$tempEmptyDir = "C:\TempEmptyDir"
```

### 4. Function to create an empty directory

```powershell
function Create-EmptyDirectory {
    param (
        [string]$path
    )
    if (Test-Path -Path $path) {
        Remove-Item -Path $path -Recurse -Force
    }
    New-Item -ItemType Directory -Path $path
}
```

### 5. Function to remove the user folder

```powershell
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
```

### 6. Main Script Logic

```powershell
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
```

## Usage Instructions

### 1. Upload the Script

Upload the script to the target machine where the user folder is located.

### 2. Set up Mapped Drive

Set up a mapped drive to your target folder using the following command:

```powershell
net use J: \\SERVER\Path\To\NetDrive /user:domain\administrator P4ssWord
```

### 3. Initiate the Transfer

Use this command to initiate the transfer:

```powershell
.\moveFolder2NetDrive.ps1 -source "C:\Path\To\Origin" -destination "J:" -username "domain\administrator" -password 'PassWord'
```

## Full Script

Here is the complete script combining all the above steps:

```powershell
# Set the username variable from an environment variable
$folderName = $env:folderName

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

# Set up Mapped Drive
net use J: \\SERVER\Path\To\NetDrive /user:domain\administrator P4ssWord

# Initiate the Transfer
.\moveFolder2NetDrive.ps1 -source "C:\Path\To\Origin" -destination "J:" -username "domain\administrator" -password 'PassWord'
```

This README provides a step-by-step guide on how to use the script to delete a user folder and transfer it to a network drive. Make sure to customize the paths, usernames, and passwords as per your requirements.
```
