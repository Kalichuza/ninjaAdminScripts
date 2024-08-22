<#
.SYNOPSIS
    Creates a desktop shortcut to a local file, folder, or application.

.DESCRIPTION
    This script creates a shortcut on the user's desktop to a specified local resource (file, folder, or application).
    The script can also optionally set a custom icon for the shortcut.

.PARAMETER TargetPath
    The path to the local file, folder, or application that the shortcut will point to.

.PARAMETER ShortcutName
    The name of the shortcut that will be created on the desktop.

.PARAMETER IconPath
    (Optional) The path to a custom icon file to use for the shortcut. If not provided, the default icon for the target will be used.

.EXAMPLE
    New-LocalShortcut -TargetPath "C:\Program Files\MyApp\MyApp.exe" -ShortcutName "MyApp"
    This will create a shortcut named "MyApp" on the desktop pointing to "C:\Program Files\MyApp\MyApp.exe".

.EXAMPLE
    New-LocalShortcut -TargetPath "C:\My Documents\MyFile.txt" -ShortcutName "MyFile" -IconPath "C:\Icons\MyIcon.ico"
    This will create a shortcut named "MyFile" on the desktop pointing to "C:\My Documents\MyFile.txt" with a custom icon.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$TargetPath,

    [Parameter(Mandatory = $true)]
    [string]$ShortcutName,

    [Parameter(Mandatory = $false)]
    [string]$IconPath
)

# Get the path to the user's desktop
$desktopPath = [System.Environment]::GetFolderPath('Desktop')

# Define the full path for the shortcut
$shortcutPath = Join-Path -Path $desktopPath -ChildPath "$ShortcutName.lnk"

# Create the shortcut using COM object
$shortcut = (New-Object -ComObject WScript.Shell).CreateShortcut($shortcutPath)
$shortcut.TargetPath = $TargetPath

# Set the icon if provided
if ($IconPath) {
    $shortcut.IconLocation = $IconPath
}

# Save the shortcut
$shortcut.Save()

Write-Output "Shortcut created on the desktop: $shortcutPath"
