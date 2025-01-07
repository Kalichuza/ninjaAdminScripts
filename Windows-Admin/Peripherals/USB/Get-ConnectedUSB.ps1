<#PSScriptInfo

.VERSION 1.1

.GUID 286b9b2b-5920-4eea-9ee1-11a59ca9efb0

.AUTHOR Kalichuza

.PRIVATEDATA

.NOTES This version is a litte bit more descriptive and creates a custom PSObject that can be filtered. 

#>

<# 

.DESCRIPTION 
Gets the stats of the currently connected usb devices
#>

# Get all USB devices from Win32_USBHub
function Get-UsbDevices {
    try {
        # Retrieve USB devices using CIM
        $devices = Get-CimInstance -ClassName Win32_PnPEntity -Namespace "root/cimv2" |
                   Where-Object { $_.Description -like "*USB*" } |
                   Select-Object -Property Name, DeviceID, Status
    } catch {
        Write-Error "Failed to retrieve USB device information using CIM. Error: $_"
        return
    }

    # Return structured objects for further filtering
    $devices | ForEach-Object {
        [PSCustomObject]@{
            Status   = $_.Status
            Name     = $_.Name
            DeviceID = $_.DeviceID
        }
    }
}

Get-UsbDevices | Format-Table -AutoSize