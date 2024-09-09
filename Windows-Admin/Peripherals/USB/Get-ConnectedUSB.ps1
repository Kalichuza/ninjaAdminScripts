# Get all USB devices from Win32_USBHub
$usbDevices = Get-WmiObject -Class Win32_USBHub

# Output the USB device details
if ($usbDevices) {
    $usbDevices | Select-Object DeviceID, Description, PNPDeviceID, Status
} else {
    Write-Output "No USB devices found."
}
