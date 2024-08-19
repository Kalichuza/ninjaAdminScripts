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

# Add VirtIO drivers to the Windows PE environment (This ensures network and disk drivers are loaded)
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddDriverPath $virtioDriversPath -Verbose

# Dismount the VirtIO ISO after use
Dismount-DiskImage -ImagePath $virtioIsoPath

# Add unattend.xml file or other custom files to the WinPE environment
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddFile -FilePath "P:\Path\to\unattend.xml" -Destination "X:\unattend.xml" -Verbose

# Add additional custom files, such as provisioning scripts or other configurations
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddFile -FilePath "P:\Path\to\custom\files\*" -Destination "X:\OSDCloud\Automate\Provisioning" -Verbose

# Optionally specify the custom deployment script URL
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -WebPSScript "https://raw.githubusercontent.com/Kalichuza/ninjaAdminScripts/main/Windows-ImageDeployment/Dynamic-Deploy-10.ps1" -Verbose

# Create the ISO directly using OSDCloud's built-in capabilities
New-OSDCloudISO -WorkspacePath C:\OSDCloud

Write-Host "ISO creation complete. The ISO is located in C:\OSDCloud\ISO"

# Deploy Windows using OSDCloud with appropriate OS version and edition
Write-Host -ForegroundColor Green "Starting OSDCloud ZTI"
Start-Sleep -Seconds 5

# Select the OS version to deploy. Comment out the one you don't need.
#Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 22H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail -ZTI

Start-OSDCloud -OSVersion 'Windows 10' -OSBuild 22H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail -ZTI

# Notify the user about the impending shutdown
Write-Host -ForegroundColor Green "Shutting down in 20 seconds to allow boot device change!"
Start-Sleep -Seconds 20

# Shut down instead of rebooting to allow time to switch the boot device
wpeutil shutdown
