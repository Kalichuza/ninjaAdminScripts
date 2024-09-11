param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Management", "CSE", "GPO")]
    [string]$Role,  # Role of the machine: Management, CSE, GPO
    [string]$MsiPath = "\\path\to\LAPS.x64.msi",  # Default MSI path for x64 version
    [string]$LogPath = "C:\LAPSInstall.log"  # Log file path
)

# Check if the MSI exists
if (-Not (Test-Path -Path $MsiPath)) {
    Write-Error "MSI file not found at $MsiPath"
    exit 1
}

# Determine components to install based on the role
switch ($Role) {
    "Management" {
        $features = "ManagementTools"
        Write-Host "Installing Management Tools..."
    }
    "CSE" {
        $features = "Client"
        Write-Host "Installing Client Side Extensions..."
    }
    "GPO" {
        $features = "GPO"
        Write-Host "Installing Group Policy Administrative Templates..."
    }
}

# Install LAPS with the selected components
$arguments = "/i `"$MsiPath`" /quiet /norestart /log `"$LogPath`" ADDLOCAL=$features"
Start-Process msiexec.exe -ArgumentList $arguments -Wait -NoNewWindow

# Check installation result
if ($LASTEXITCODE -eq 0) {
    Write-Host "LAPS installation completed successfully."
} else {
    Write-Error "LAPS installation failed. Check the log at $LogPath for details."
}
