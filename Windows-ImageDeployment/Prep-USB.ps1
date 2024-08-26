<#
.SYNOPSIS
Prepares a USB drive for use with the Windows image.

.DESCRIPTION
This script clears the specified WinPE path and Unattend.xml path on a USB drive and copies new provisioning files into them.

.PARAMETER WinPEPathProvisioning
The path where the WinPE files will be copied to on the USB drive.

.PARAMETER UnattendXMLPathUSB
The path where the Unattend.xml file will be copied to on the USB drive.

.PARAMETER ProvisioningFolderPath
The path to the folder containing the provisioning files to copy.

.PARAMETER UnattendXMLPathProvisioning
The path to the Unattend.xml file that will be copied to the USB drive.

.EXAMPLE
.\Prep-USB.ps1 -.\Prep-USB.ps1 -WinPEPathProvisioning 'H:\OSDCloud\Automate\Provisioning\' -UnattendXMLPathUSB 'H:\unattend.xml' -ProvisioningFolderPath 'P:\Local\Path\to\Provisioning\Files\' -UnattendXMLPathProvisioning 'P:\Local\Path\to\Unattend.xml' -WinPEPathProvisioning 'H:\OSDCloud\Automate\Provisioning\' -UnattendXMLPathProvisioning 'P:\path\to\unattend.xml'
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$WinPEPathProvisioning,

    [Parameter(Mandatory = $true)]
    [string]$UnattendXMLPathUSB,

    [Parameter(Mandatory = $true)]
    [string]$ProvisioningFolderPath,

    [Parameter(Mandatory = $true)]
    [string]$UnattendXMLPathProvisioning
)

Write-Host "Starting USB preparation process..." -ForegroundColor Cyan

# Clear the WinPE path if it exists
try {
    if (Test-Path $WinPEPathProvisioning) {
        Write-Host "Clearing the contents of $WinPEPathProvisioning..." -ForegroundColor Yellow
        Get-ChildItem $WinPEPathProvisioning | Remove-Item -Recurse -Force
        Write-Host "$WinPEPathProvisioning has been cleared."
    } else {
        Write-Host "$WinPEPathProvisioning does not exist. Creating directory." -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $WinPEPathProvisioning -Force
    }

    Write-Host "Copying provisioning files from $ProvisioningFolderPath to $WinPEPathProvisioning..." -ForegroundColor Yellow
    Copy-Item "$ProvisioningFolderPath\*" -Destination $WinPEPathProvisioning -Recurse -Force
    Write-Host "Provisioning files have been copied to $WinPEPathProvisioning." -ForegroundColor Green
} catch {
    Write-Error "Failed to clear or copy files to $WinPEPathProvisioning. Error: $_"
    return
}

# Clear and copy the Unattend.xml file
try {
    if (Test-Path $UnattendXMLPathUSB) {
        Write-Host "Clearing the existing Unattend.xml at $UnattendXMLPathUSB..." -ForegroundColor Yellow
        Remove-Item $UnattendXMLPathUSB -Force
        Write-Host "Unattend.xml at $UnattendXMLPathUSB has been cleared."
    } 

    Write-Host "Copying Unattend.xml from $UnattendXMLPathProvisioning to $UnattendXMLPathUSB..." -ForegroundColor Yellow
    Copy-Item $UnattendXMLPathProvisioning -Destination $UnattendXMLPathUSB -Force
    Write-Host "Unattend.xml has been copied to $UnattendXMLPathUSB." -ForegroundColor Green
} catch {
    Write-Error "Failed to clear or copy Unattend.xml. Error: $_"
    return
}

Write-Host "USB preparation process completed successfully." -ForegroundColor Cyan
    
