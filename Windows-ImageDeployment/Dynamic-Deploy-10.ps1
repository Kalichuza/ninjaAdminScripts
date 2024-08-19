Write-Host -ForegroundColor Green "Starting OSDCloud ZTI"
Start-Sleep -Seconds 5

# Specify the OS to deploy. Uncomment the version needed.
#Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 22H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail -ZTI

Start-OSDCloud -OSVersion 'Windows 10' -OSBuild 22H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail -ZTI

# Network and Disk Configuration (VirtIO optimization)
# Ensure that VirtIO drivers for both network and disk are preloaded.
# This assumes the drivers have been added to the WinPE environment.

# Notify the user about the impending shutdown
Write-Host -ForegroundColor Green "Shutting down in 20 seconds to allow boot device change!"
Start-Sleep -Seconds 20

# Shut down instead of rebooting
wpeutil shutdown

# Optional: Post-deployment script for Proxmox optimization (can be triggered manually or automated)
# Install QEMU Guest Agent
# This would be part of the post-deployment process
# Install-WindowsFeature -Name "QEMU Guest Agent" -IncludeAllSubFeature
