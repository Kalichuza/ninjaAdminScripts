[CmdletBinding()]
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
Invoke-WebRequest -Uri $IconUrl -OutFile $iconPath

# Create the .url file with the URL and icon information
$shortcutContent = @"
[InternetShortcut]
URL=$Url
IconFile=$iconPath
IconIndex=0
"@

Set-Content -Path $shortcutPath -Value $shortcutContent

Write-Output "Shortcut created on the desktop: $shortcutPath"
Write-Output "Icon saved to: $iconPath"
