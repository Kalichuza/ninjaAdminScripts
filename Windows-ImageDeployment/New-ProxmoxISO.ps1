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

# Add VirtIO drivers to the Windows PE environment and specify the custom deployment script URL
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddDriverPath $virtioDriversPath -WebPSScript "https://raw.githubusercontent.com/Kalichuza/ninjaAdminScripts/main/Windows-ImageDeployment/Dynamic-Deploy-10.ps1" -Verbose

# Dismount the VirtIO ISO after use
Dismount-DiskImage -ImagePath $virtioIsoPath

# Copy additional files or add any custom files to the workspace
# This can include the unattend.xml file or any other custom scripts/configurations
# Example:
# Copy-Item -Path "C:\path\to\custom\files\*" -Destination "C:\OSDCloud\Automate\Provisioning" -Recurse

# Now, create the ISO with oscdimg to include any extra space for future modifications
$sourcePath = "C:\OSDCloud"
$outputIsoPath = "C:\OSDCloud\CustomWindowsVM.iso"
oscdimg -m -o -lCustomWinVM -b"$sourcePath\boot\etfsboot.com" $sourcePath $outputIsoPath

Write-Host "ISO creation complete. The ISO is located at $outputIsoPath"
