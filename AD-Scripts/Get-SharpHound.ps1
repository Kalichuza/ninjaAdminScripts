
[CmdletBinding()]
param (
    [Parameter()]
    [string]$FilePath,
    
    [Parameter()]
    [string]$ShUrl = "https://github.com/BloodHoundAD/BloodHound/raw/refs/heads/master/Collectors/SharpHound.exe"

)

$Script = @("Get-RemoteFile.ps1")

foreach ($s in $Script) {
    if (-not (Get-Command -Name $s -ErrorAction SilentlyContinue)) {
        Install-Script -Name $s -Scope CurrentUser -Force
    }
}

Get-RemoteFile.ps1 -Url $ShUrl -FilePath $filePath

Write-Host "SharpHound.exe saved to $filePath"

# .\SharpHound.exe -c All -d C:\Path\To\Your\Desired\Directory
