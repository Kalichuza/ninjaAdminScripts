# Get all USB devices
$usbDevices = Get-WmiObject -Query "SELECT * FROM Win32_USBControllerDevice"

# Output the USB devices
foreach ($device in $usbDevices) {
    $devicePath = [System.Management.ManagementObject]($device.Dependent)
    $deviceInfo = Get-WmiObject -Query "SELECT * FROM Win32_PnPEntity WHERE DeviceID='$($devicePath.DeviceID)'"
    if ($deviceInfo) {
        $deviceInfo | Select-Object Name, DeviceID, Manufacturer, Description
    }
}
