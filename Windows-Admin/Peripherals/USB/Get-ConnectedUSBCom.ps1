
<#PSScriptInfo

.VERSION 1.0

.GUID dd35add9-e72a-41bd-9bef-f41a38085a3b

.AUTHOR Kalichuza

.COMPANYNAME

.COPYRIGHT

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 A simple script that uses COM objects to list deviced connected via usb 

#> 

<#
.DESCRIPTION
Gets the stats of the currently connected USB devices using COM objects.
#>

<#
<#
.DESCRIPTION
Gets the stats of the currently connected USB devices using CIM (PowerShell Core compatible).
#>

# Query USB devices using CIM
try {
    $usbDevices = Get-CimInstance -ClassName Win32_USBHub -Namespace "root/cimv2"
    if ($usbDevices) {
        $usbDevices | Select-Object DeviceID, Description, PNPDeviceID, Status
    } else {
        Write-Output "No USB devices found."
    }
} catch {
    Write-Error "Failed to retrieve USB device information. Error: $_"
}



