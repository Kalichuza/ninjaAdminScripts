
<#PSScriptInfo

.VERSION 1.0

.GUID de6b9531-85d9-4717-b169-e015ac4a5e8f

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
 Creates desktop Icom for the logged on user 

.EXAMPLE
New-DesktopShortCut -LinkPath "C:\Windows\System32\notepad.exe" -LinkName "Notepad" -IconPath "C:\Windows\System32\notepad.ico"

#> 

param (
    [Parameter(Mandatory)]
    [string]$LinkPath,
    
    [Parameter(Mandatory)]
    [string]$LinkName,

    [Parameter()]
    [string]$IconPath,

    [Parameter()]
    [switch]$IsUrl
)

function New-DesktopShortCut {
    param (
        [string]$LinkPath,
        [string]$LinkName,
        [string]$IconPath,
        [switch]$IsUrl
    )

    $DesktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), "$LinkName.lnk")
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($DesktopPath)
    
    if ($IsUrl) {
        $Shortcut.TargetPath = $LinkPath
        if ($IconPath) {
            $Shortcut.IconLocation = $IconPath
        }
    } else {
        $Shortcut.TargetPath = $LinkPath
        if ($IconPath) {
            $Shortcut.IconLocation = $IconPath
        }
    }

    $Shortcut.Save()
}

# Call the function with the provided parameters
New-DesktopShortCut -LinkPath $LinkPath -LinkName $LinkName -IconPath $IconPath -IsUrl:$IsUrl


