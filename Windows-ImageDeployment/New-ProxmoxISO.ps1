# Set execution policy to allow running scripts
Set-ExecutionPolicy RemoteSigned -Force

# Install OSD module if not already installed
Install-Module OSD -Force

# Import OSD module
Import-Module OSD -Force

# Create OSDCloud template
New-OSDCloudTemplate

# Create OSDCloud workspace
New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud

# Download VirtIO drivers using the direct download link
$virtioDriversUrl = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.262-2/virtio-win.iso"
$virtioIsoPath = "C:\OSDCloud\virtio-win.iso"
Invoke-WebRequest -Uri $virtioDriversUrl -OutFile $virtioIsoPath

# Mount the VirtIO ISO
Mount-DiskImage -ImagePath $virtioIsoPath

# Get the drive letter assigned to the mounted VirtIO ISO
$virtioDriveLetter = (Get-DiskImage -ImagePath $virtioIsoPath | Get-Volume).DriveLetter

# Correctly format the path to the VirtIO drivers
$virtioDriversPath = $virtioDriveLetter + ":\"

# Add VirtIO drivers to the Windows PE environment
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddDriverPath $virtioDriversPath -Verbose

# Dismount the VirtIO ISO after use
Dismount-DiskImage -ImagePath $virtioIsoPath

# Edit the Windows PE environment and add your custom files. For example, msi files, ppkg files, or unattend.xml files
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddFile -FilePath "P:\Path\to\unattend.xml" -Destination "X:\unattend.xml" -Verbose

# Note: If you have multiple files or folders, you can use -AddFile multiple times or specify a folder structure:
# Example for a folder:
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddFile -FilePath "P:\Path\to\custom\files\*" -Destination "X:\OSDCloud\Automate\Provisioning" -Verbose

# Optionally specify the custom deployment script URL
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -WebPSScript "https://raw.githubusercontent.com/Kalichuza/ninjaAdminScripts/main/Windows-ImageDeployment/Dynamic-Deploy-10.ps1" -Verbose

# Create the ISO directly using OSDCloud's built-in capabilities
New-OSDCloudISO -WorkspacePath C:\OSDCloud

Write-Host "ISO creation complete. The ISO is located in C:\OSDCloud\ISO"
