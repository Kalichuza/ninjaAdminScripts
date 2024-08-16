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

# You can optionally include Hyper-V Integration Services drivers here if needed, but Windows generally has these built-in.

# Example (for demonstration purposes):
# Download Hyper-V Integration Services (for older versions of Windows, if needed)
# Note: Modern Windows versions have Hyper-V integration services built-in, so this is usually unnecessary.
$hypervDriversUrl = "https://example.com/hyper-v-integration-services.iso"  # Replace with the correct URL if needed
$hypervIsoPath = "C:\OSDCloud\hyper-v-integration-services.iso"
Invoke-WebRequest -Uri $hypervDriversUrl -OutFile $hypervIsoPath

# Mount the Hyper-V ISO (if you have any custom drivers you want to add)
Mount-DiskImage -ImagePath $hypervIsoPath

# Get the drive letter assigned to the mounted ISO
$hypervDriveLetter = (Get-DiskImage -ImagePath $hypervIsoPath | Get-Volume).DriveLetter

# Correctly format the path to the Hyper-V drivers (if needed)
$hypervDriversPath = $hypervDriveLetter + ":\"

# Add any necessary Hyper-V drivers to the Windows PE environment (if you have any)
# Example: Add drivers if they are not natively included (usually unnecessary for modern Windows)
# Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddDriverPath $hypervDriversPath -WebPSScript "https://your-deployment-script-url.ps1" -Verbose

# Dismount the Hyper-V ISO after use (if used)
Dismount-DiskImage -ImagePath $hypervIsoPath

# Copy additional files or add any custom files to the workspace
# This can include the unattend.xml file or any other custom scripts/configurations
# Example:
# Copy-Item -Path "C:\path\to\custom\files\*" -Destination "C:\OSDCloud\Automate\Provisioning" -Recurse

# Now, create the ISO with oscdimg to include any extra space for future modifications
$sourcePath = "C:\OSDCloud"
$outputIsoPath = "C:\OSDCloud\CustomWindowsHyperV.iso"
oscdimg -m -o -lCustomWinVM -b"$sourcePath\boot\etfsboot.com" $sourcePath $outputIsoPath

Write-Host "ISO creation complete. The ISO is located at $outputIsoPath"
