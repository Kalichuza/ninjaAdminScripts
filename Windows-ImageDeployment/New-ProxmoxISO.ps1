# Set execution policy
Set-ExecutionPolicy RemoteSigned -Force

# Install OSDCloud module if not already installed
Install-Module OSD -Force

# Import the OSDCloud module
Import-Module OSD -Force

# Create a new OSDCloud Template
New-OSDCloudTemplate

# Create a new OSDCloud Workspace
New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud

# Copy custom files to the OSDCloud Workspace
$workspacePath = "C:\OSDCloud"

# Ensure directories exist
$provisioningPath = Join-Path -Path $workspacePath -ChildPath "WinPE\OSDCloud\Automate\Provisioning"
$customFilesPath = Join-Path -Path $workspacePath -ChildPath "WinPE\OSDCloud\Automate\CustomFiles"

New-Item -Path $provisioningPath -ItemType Directory -Force
New-Item -Path $customFilesPath -ItemType Directory -Force

# Copy your PPKG, MSI, and unattend.xml files
Copy-Item -Path "C:\Path\to\your\unattend.xml" -Destination $provisioningPath
Copy-Item -Path "C:\Path\to\your\custom.ppkg" -Destination $provisioningPath
Copy-Item -Path "C:\Path\to\your\custom.msi" -Destination $customFilesPath

# Edit the OSDCloud WinPE image, adding your custom script
Edit-OSDCloudWinPE -WorkspacePath $workspacePath -CloudDriver * -WebPSScript "https://raw.githubusercontent.com/Kalichuza/ninjaAdminScripts/main/Windows-ImageDeployment/Dynamic-Deploy.ps1" -Verbose

# Create a new OSDCloud ISO
New-OSDCloudISO -WorkspacePath $workspacePath

# Optional: Update OSDCloud USB
Update-OSDCloudUSB
