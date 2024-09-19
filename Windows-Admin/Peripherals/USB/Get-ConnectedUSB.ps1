<#PSScriptInfo

.VERSION 1.0

.GUID 286b9b2b-5920-4eea-9ee1-11a59ca9efb0

.AUTHOR Kalichuza

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
Gets the stats of the currently connected usb devices
#>

# Get all USB devices from Win32_USBHub
$usbDevices = Get-WmiObject -Class Win32_USBHub

# Output the USB device details
if ($usbDevices) {
    $usbDevices | Select-Object DeviceID, Description, PNPDeviceID, Status
} else {
    Write-Output "No USB devices found."
}

