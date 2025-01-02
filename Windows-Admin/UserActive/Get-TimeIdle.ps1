
<#PSScriptInfo

.VERSION 1.0

.GUID 9af7823c-1d99-476c-8e4b-d01bd212324e

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
 Checks a device's idle time 

#> 



Add-Type @"
using System;
using System.Runtime.InteropServices;

public class IdleTime
{
    [DllImport("user32.dll")]
    public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    [StructLayout(LayoutKind.Sequential)]
    public struct LASTINPUTINFO
    {
        public uint cbSize;
        public uint dwTime;
    }

    public static uint GetIdleTime()
    {
        LASTINPUTINFO lastInPut = new LASTINPUTINFO();
        lastInPut.cbSize = (uint)Marshal.SizeOf(lastInPut);
        if (!GetLastInputInfo(ref lastInPut)) return 0;
        return ((uint)Environment.TickCount - lastInPut.dwTime) / 1000;
    }
}
"@

# Call the method and get the idle time in seconds
$idleTimeSeconds = [IdleTime]::GetIdleTime()

# Convert seconds to total minutes
$idleTimeMinutes = [math]::Floor($idleTimeSeconds / 60)

# Check if idle time exceeds 60 minutes
if ($idleTimeMinutes -ge 60) {
    $hours = [math]::Floor($idleTimeMinutes / 60)
    $minutes = $idleTimeMinutes % 60
    Write-Output "System idle time: $hours hour(s) and $minutes minute(s)"
} else {
    Write-Output "System idle time: $idleTimeMinutes minute(s)"
}
