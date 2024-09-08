[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$Url,

    [Parameter(Mandatory = $true)]
    [string]$ShortcutName
)

function Create-Shortcut {
    param (
        [string]$Path,
        [string]$TargetUrl
    )
    
    $WScriptShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WScriptShell.CreateShortcut($Path)
    $Shortcut.TargetPath = $TargetUrl
    $Shortcut.Save()
}

# Get the path to the user's desktop
$desktopPath = [System.Environment]::GetFolderPath('Desktop')

# Define the full path for the shortcut
$shortcutPath = Join-Path -Path $desktopPath -ChildPath "$ShortcutName.url"

# Create the shortcut
Create-Shortcut -Path $shortcutPath -TargetUrl $Url

Write-Output "Shortcut created on the desktop: $shortcutPath"
