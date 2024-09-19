<#PSScriptInfo

.VERSION 1.0.3

.GUID 89078aac-a617-4b05-b6f0-f8d95ffc4ee9

.AUTHOR Kalichuza

#>

<# 

.DESCRIPTION 
One click PWSH Core GPO Setup.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$admxUrl = "https://github.com/PowerShell/PowerShell/raw/master/assets/GroupPolicy/PowerShellCoreExecutionPolicy.admx",
    
    [Parameter(Mandatory=$false)]
    [string]$admlUrl = "https://github.com/PowerShell/PowerShell/raw/master/assets/GroupPolicy/PowerShellCoreExecutionPolicy.adml"
)

Install-Script -name Get-RemoteFile -Force
function Download-File {
    param (
        [Parameter(Mandatory=$true)]
        [string]$url,
        
        [Parameter(Mandatory=$true)]
        [string]$destinationPath
    )

    try {
        Write-Host "Downloading $url to $destinationPath..."
        Get-RemoteFile.ps1 -Url $url -FilePath $destinationPath
        Write-Host "Downloaded successfully!"
    } catch {
        Write-Error "Failed to download $($url): $_"
    }
}

# Define file paths
$admxPath = "$($env:USERPROFILE)\Desktop\PowerShellCoreExecutionPolicy.admx"
$admlPath = "$($env:USERPROFILE)\Desktop\PowerShellCoreExecutionPolicy.adml"

# Download ADMX and ADML files
Download-File -url $admxUrl -destinationPath $admxPath
Download-File -url $admlUrl -destinationPath $admlPath

# Check if the files were downloaded
if ((Test-Path $admxPath) -and (Test-Path $admlPath)) {
    
    # Ensure the destination directories exist
    if (-not (Test-Path "C:\Windows\PolicyDefinitions")) {
        Write-Error "PolicyDefinitions folder not found!"
        exit
    }

    if (-not (Test-Path "C:\Windows\PolicyDefinitions\en-US")) {
        Write-Error "Language folder (en-US) not found!"
        exit
    }

    # Move ADMX and ADML files to the appropriate locations
    Move-Item $admxPath "C:\Windows\PolicyDefinitions\PowerShellCoreExecutionPolicy.admx" -Force
    Move-Item $admlPath "C:\Windows\PolicyDefinitions\en-US\PowerShellCoreExecutionPolicy.adml" -Force

    Write-Host "ADMX and ADML files have been moved successfully to the correct directories."
} else {
    Write-Error "One or both files were not downloaded correctly."
}
