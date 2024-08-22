<#
.SYNOPSIS
    Creates a desktop shortcut with a custom icon pointing to a specified URL.

.DESCRIPTION
    This script downloads an icon from a specified URL, saves it to the user's Pictures folder, 
    and then creates a shortcut on the user's desktop pointing to a specified URL with the downloaded icon.

.PARAMETER Url
    The URL that the shortcut will point to.

.PARAMETER ShortcutName
    The name of the shortcut that will be created on the desktop.

.PARAMETER IconUrl
    The URL from which to download the icon to be used for the shortcut.

.EXAMPLE
    New-DesktopShortcut -Url "https://example.com" -ShortcutName "ExampleSite" -IconUrl "https://example.com/icon.ico"
    This will create a shortcut named "ExampleSite" on the desktop pointing to "https://example.com" with an icon downloaded from "https://example.com/icon.ico".
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Url,

    [Parameter(Mandatory = $true)]
    [string]$ShortcutName,

    [Parameter(Mandatory = $true)]
    [string]$IconUrl
)

# Get the path to the user's desktop and Pictures folder
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$picturesPath = [System.Environment]::GetFolderPath('MyPictures')

# Define the full path for the shortcut
$shortcutPath = Join-Path -Path $desktopPath -ChildPath "$ShortcutName.url"

# Define the path for the icon in the Pictures folder
$iconFileName = "$ShortcutName.ico"
$iconPath = Join-Path -Path $picturesPath -ChildPath $iconFileName

# Download the icon using Invoke-WebRequest
try {
    Invoke-WebRequest -Uri $IconUrl -OutFile $iconPath -ErrorAction Stop
    Write-Output "Icon downloaded successfully: $iconPath"
} catch {
    Write-Error "Failed to download icon from $IconUrl. Error: $_"
    exit 1
}

# Create the .url file with the URL and icon information
$shortcutContent = @"
[InternetShortcut]
URL=$Url
IconFile=$iconPath
IconIndex=0
"@

try {
    Set-Content -Path $shortcutPath -Value $shortcutContent -ErrorAction Stop
    Write-Output "Shortcut created on the desktop: $shortcutPath"
} catch {
    Write-Error "Failed to create the shortcut at $shortcutPath. Error: $_"
    exit 1
}
