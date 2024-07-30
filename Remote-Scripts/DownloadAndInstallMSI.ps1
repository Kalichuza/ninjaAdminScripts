<#
.SYNOPSIS
    This script downloads an MSI file from a specified URL and installs it.

.DESCRIPTION
    The script takes a URL to download an MSI file and a filename to save the MSI file. It downloads the MSI file, installs it in quiet mode, and then deletes the downloaded MSI file.

.PARAMETER url
    The URL of the MSI file to download.

.PARAMETER filename
    The name to save the downloaded MSI file as.

.EXAMPLE
    .\DownloadAndInstallMSI.ps1 -url "http://example.com/file.msi" -filename "setup"
    This command downloads the MSI file from "http://example.com/file.msi", saves it as "setup.msi" in the TEMP folder, installs it, and then deletes the downloaded file.

#>

param(
    [string]$url,
    [string]$filename
)

# Define the path to save the MSI file in the global temp folder
$downloadPath = Join-Path -Path $env:TEMP -ChildPath "$filename.msi"

try {
    # Download the MSI file using curl
    Start-Process -Wait -FilePath "curl" -ArgumentList "-o", "$downloadPath", "$url"
    Write-Output "File successfully downloaded from $url to $downloadPath."

    # Install the MSI file in quiet mode
    Start-Process -Wait -FilePath "msiexec.exe" -ArgumentList "/i $downloadPath /quiet"
    Write-Output "MSI installation completed."

    # Remove the downloaded MSI file
    Remove-Item -Path $downloadPath -Force
    Write-Output "Downloaded file $downloadPath deleted."
}
catch {
    Write-Output "An error occurred: $_"
}
