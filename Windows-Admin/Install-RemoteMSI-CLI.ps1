<#
.SYNOPSIS
    Downloads and installs a software package silently if it's not already installed.

.DESCRIPTION
    This script checks for the presence of a specified software by looking for a registry key.
    If the software is not found, the script downloads the installer from the provided URL,
    saves it to a specified location, and installs it silently using the specified installation arguments.

.PARAMETER DownloadUrl
    The URL from which to download the installer file.

.PARAMETER TempFilePath
    The path where the installer will be saved on the local machine.

.PARAMETER RegistryKeyPath
    The registry key path used to check if the software is already installed.

.PARAMETER InstallArguments
    The command-line arguments to pass to the installer for silent installation.

.EXAMPLE
    .\InstallSoftware.ps1 -DownloadUrl "https://yoururl.com/file.msi" -TempFilePath "C:\Windows\Temp\yourfile.msi" `
    -RegistryKeyPath "HKLM:\SOFTWARE\YourVendor\YourSoftware" -InstallArguments "--quiet"

    This example checks if "YourSoftware" is installed by looking for the registry key at "HKLM:\SOFTWARE\YourVendor\YourSoftware".
    If not installed, it downloads the installer from "https://yoururl.com/file.msi" to "C:\Windows\Temp\yourfile.msi" and installs it silently.

.NOTES
    Author: Kalichuza
    Contact: https://github.com/kalichuza
    Date: 2024-08-14
    Version: 1.0
#>

[CmdletBinding()]
param (
    [string]$DownloadUrl,  # URL to download the installer
    [string]$TempFilePath,  # Temporary file path to save the installer
    [string]$RegistryKeyPath,  # Registry key path to check if software is installed
    [string]$InstallArguments = "--quiet"  # Installation arguments for silent install
)

# Function to check if the software is installed
function Check-SoftwareInstalled {
    param (
        [string]$keyPath
    )

    try {
        $softwareKey = Get-ItemProperty $keyPath -ErrorAction SilentlyContinue
        if ($softwareKey) {
            Write-Host "Software is already installed. Exiting script."
            exit 0
        } else {
            Write-Host "Software is not installed. Proceeding with installation."
        }
    } catch {
        Write-Host "Error checking for software installation: $_"
        exit 1
    }
}

# Function to download the file
function Download-File {
    param (
        [string]$url,
        [string]$outputPath
    )

    # Delete the file if it already exists
    if (Test-Path $outputPath) {
        Remove-Item $outputPath -Force
    }

    try {
        Write-Host "Starting download from $url..."
        Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
        Write-Host "Download completed successfully."
    } catch {
        Write-Error "Failed to download file from $url. Error: $_"
        exit 1
    }
}

# Function to install the software silently
function Install-Software {
    param (
        [string]$installerPath,
        [string]$arguments
    )

    try {
        Write-Host "Starting installation of $installerPath..."
        Start-Process -FilePath $installerPath -ArgumentList $arguments -Wait -NoNewWindow
        Write-Host "Installation completed successfully."
    } catch {
        Write-Error "Failed to install software from $installerPath. Error: $_"
        exit 1
    }
}

# Check if the software is already installed
Check-SoftwareInstalled -keyPath $RegistryKeyPath

# Download the file
Download-File -url $DownloadUrl -outputPath $TempFilePath

# Install the software
Install-Software -installerPath $TempFilePath -arguments $InstallArguments

# Confirmation message
Write-Host "Software has been downloaded and installed successfully."
