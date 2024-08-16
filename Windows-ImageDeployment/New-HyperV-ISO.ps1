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

# If Hyper-V Integration Services drivers are needed (mostly for older Windows versions),
# you can download and add them here. For most modern Windows versions, this step is unnecessary.

# Example (for demonstration purposes):
# $hypervDriversUrl = "https://example.com/hyper-v-integration-services.iso"  # Replace with the correct URL if needed
# $hypervIsoPath = "C:\OSDCloud\hyper-v-integration-services.iso"
# Invoke-WebRequest -Uri $hypervDriversUrl -OutFile $hypervIsoPath

# Mount the Hyper-V ISO if you need to extract any drivers
# Mount-DiskImage -ImagePath $hypervIsoPath

# Get the drive letter assigned to the mounted ISO (if used)
# $hypervDriveLetter = (Get-DiskImage -ImagePath $hypervIsoPath | Get-Volume).DriveLetter

# Correctly format the path to the Hyper-V drivers (if needed)
# $hypervDriversPath = $hypervDriveLetter + ":\"

# Add custom files to the WinPE environment using OSDCloud
# Include the unattend.xml and any other necessary provisioning files

# Example: Add unattend.xml to the root of the WinPE environment
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddFile -FilePath "C:\path\to\unattend.xml" -Destination "X:\unattend.xml" -Verbose

# Example: Add all files in a provisioning folder to the WinPE environment
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -AddFile -FilePath "C:\path\to\Provisioning\*" -Destination "X:\Automate\Provisioning" -Verbose

# Optionally specify the custom deployment script URL
Edit-OSDCloudWinPE -WorkspacePath C:\OSDCloud -CloudDriver * -WebPSScript "https://your-deployment-script-url.ps1" -Verbose

# Dismount the Hyper-V ISO after use (if used)
# Dismount-DiskImage -ImagePath $hypervIsoPath

# Create the ISO using OSDCloud's built-in capabilities (no manual resizing needed)
New-OSDCloudISO -WorkspacePath C:\OSDCloud

Write-Host "ISO creation complete. The ISO is located in C:\OSDCloud\ISO"
