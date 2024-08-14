<#
.SYNOPSIS
    Downloads and installs Sophos software silently if it's not already installed.

.DESCRIPTION
    This script checks for the presence of Sophos software by looking for a registry key.
    If Sophos is not found, the script downloads the installer from the provided URL,
    saves it to a specified location, and installs it silently.

.NOTES
    Author: Kalichuza
    Contact: https://github.com/kalichuza
    Date: 2024-08-14
    Version: 1.0

.EXAMPLE
    .\InstallSophos.ps1

    This example runs the script to check if Sophos is installed by looking for the registry key.
    If not installed, it downloads the Sophos installer and installs it silently.
#>

[CmdletBinding()]
param ()

# Define variables
$downloadUrl = "https://dzr-api-amzn-us-west-2-fa88.api-upe.p.hmr.sophos.com/api/download/552f732bc7afbc20fe908ba4533fe6e2/SophosSetup.exe"
$tempFilePath = "C:\Windows\Temp\SophosSetup.exe"
$registryKeyPath = "HKLM:\SOFTWARE\Sophos\AutoUpdate\InstallStatus"

# Function to check if Sophos is installed
function Check-SophosInstalled {
    try {
        $sophosKey = Get-ItemProperty $registryKeyPath -ErrorAction SilentlyContinue
        if ($sophosKey) {
            Write-Host "Sophos is already installed. Exiting script."
            exit 0
        } else {
            Write-Host "Sophos is not installed. Proceeding with installation."
        }
    } catch {
        Write-Host "Error checking for Sophos installation: $_"
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

# Function to install Sophos silently
function Install-Software {
    param (
        [string]$installerPath
    )

    try {
        Write-Host "Starting installation of $installerPath..."
        Start-Process -FilePath $installerPath -ArgumentList "--quiet" -Wait -NoNewWindow
        Write-Host "Installation completed successfully."
    } catch {
        Write-Error "Failed to install software from $installerPath. Error: $_"
        exit 1
    }
}

# Check if Sophos is already installed
Check-SophosInstalled

# Download the file
Download-File -url $downloadUrl -outputPath $tempFilePath

# Install the software
Install-Software -installerPath $tempFilePath

# Confirmation message
Write-Host "Sophos Setup has been downloaded and installed successfully."
