# Set execution policy to allow running scripts
Set-ExecutionPolicy RemoteSigned -Force

# Install OSD module
Install-Module OSD -Force

# Import OSD module
Import-Module OSD -Force

# Create OSDCloud template
New-OSDCloudTemplate

# Create OSDCloud workspace
New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud

# Download VirtIO drivers using the direct download link provided
$virtioDriversUrl = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.262-2/virtio-win.iso"
$virtioIsoPath = "C:\OSDCloud\virtio-win.iso"
Invoke-WebRequest -Uri $virtioDriversUrl -OutFile $virtioIsoPath
Mount-DiskImage -ImagePath $virtioIsoPath
$virtioDriveLetter = (Get-DiskImage -ImagePath $virtioIsoPath | Get-Volume).DriveLetter
$virtioDriversPath = "${virtioDriveLetter}:\"

# Create OSDCloud USB
New-OSDCloudUSB

# Add VirtIO drivers to the Windows PE environment and specify a custom deployment script
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddDriverPath $virtioDriversPath -WebPSScript "https://raw.githubusercontent.com/Kalichuza/ninjaAdminScripts/main/Windows-ImageDeployment/Dynamic-Deploy-10.ps1" -Verbose

# Create OSDCloud ISO
New-OSDCloudISO

# Update OSDCloud USB
Update-OSDCloudUSB

# Clean up by dismounting the ISO
Dismount-DiskImage -ImagePath $virtioIsoPath
