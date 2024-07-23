# Ninja Uninstall Script with support for removing TeamViewer if '-DelTeamViewer' parameter is used
# Usage: [-Uninstall] [-Cleanup] [-DelTeamViewer]

param (
    [Parameter(Mandatory=$false)]
    [switch]$DelTeamViewer = $false,
    [Parameter(Mandatory=$false)]
    [switch]$Cleanup,
    [Parameter(Mandatory=$false)]
    [switch]$Uninstall,
    [Parameter(Mandatory=$false)]
    [switch]$ShowError
)

# Set error preference
$ErrorActionPreference = if($ShowError) { 'Continue' } else { 'SilentlyContinue' }

Write-Progress -Activity "Running Ninja Removal Script" -PercentComplete 0

# Determine system architecture for registry paths
if([system.environment]::Is64BitOperatingSystem) {
    $ninjaPreSoftKey = 'HKLM:\SOFTWARE\WOW6432Node\NinjaRMM LLC'
    $uninstallKey = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    $exetomsiKey = 'HKLM:\SOFTWARE\WOW6432Node\EXEMSI.COM\MSI Wrapper\Installed'
} else {
    $ninjaPreSoftKey = 'HKLM:\SOFTWARE\NinjaRMM LLC'
    $uninstallKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
    $exetomsiKey = 'HKLM:\SOFTWARE\EXEMSI.COM\MSI Wrapper\Installed'
}

$ninjaSoftKey = Join-Path $ninjaPreSoftKey -ChildPath 'NinjaRMMAgent'
$ninjaDir = [string]::Empty
$ninjaDataDir = Join-Path -Path $env:ProgramData -ChildPath "NinjaRMMAgent"

# Attempt to locate NinjaRMMAgent
$ninjaDirRegLocation = Get-ItemPropertyValue -Path $ninjaSoftKey -Name Location -ErrorAction SilentlyContinue
if($ninjaDirRegLocation -and (Test-Path (Join-Path -Path $ninjaDirRegLocation -ChildPath "NinjaRMMAgent.exe"))) {
    $ninjaDir = $ninjaDirRegLocation
}

# Fallback to service path if registry location is not found
if(-not $ninjaDir) {
    $servicePath = (Get-WmiObject -Class win32_service -Filter "Name = 'NinjaRMMAgent'").PathName
    if($servicePath) {
        $ninjaDirService = ($servicePath | Split-Path).Replace("`"", "")
        if(Test-Path (Join-Path -Path $ninjaDirService -ChildPath "NinjaRMMAgentPatcher.exe")) {
            $ninjaDir = $ninjaDirService
        }
    }
}

if($Uninstall) {
    # Disable uninstall prevention and execute uninstall
    Start-Process -FilePath "$ninjaDir\NinjaRMMAgent.exe" -ArgumentList "-disableUninstallPrevention", "NOUI" -Wait
    $productID = (Get-WmiObject -Class Win32_Product -Filter "Name = 'NinjaRMMAgent'").IdentifyingNumber
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/x", $productID, "/quiet", "/norestart" -Wait
}

if($Cleanup) {
    # Stop and delete NinjaRMMAgent service
    $service = Get-Service -Name "NinjaRMMAgent" -ErrorAction SilentlyContinue
    if($service) {
        Stop-Service -Name $service -Force
        sc.exe DELETE $service
    }

    # Remove NinjaRMMAgent folders
    foreach ($path in @($ninjaDir, $ninjaDataDir)) {
        if(Test-Path $path) {
            Remove-Item -Path $path -Recurse -Force
        }
    }

    # Remove registry keys
    foreach ($keyPath in @($ninjaPreSoftKey, $uninstallKey, $exetomsiKey)) {
        if(Test-Path $keyPath) {
            Remove-Item -Path $keyPath -Recurse -Force
        }
    }
}

# Uninstall TeamViewer
if($DelTeamViewer) {
    Get-Process -Name "teamviewer*" | Stop-Process -Force
    $teamViewerPaths = @("${env:ProgramFiles(x86)}\TeamViewer\uninstall.exe", "${env:ProgramFiles}\TeamViewer\uninstall.exe")
    foreach ($path in $teamViewerPaths) {
        if(Test-Path $path) {
            Start-Process -FilePath $path -ArgumentList "/S" -Wait
        }
    }
    Remove-Item -Path "HKLM:\SOFTWARE\TeamViewer" -Recurse -Force
    Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\TeamViewer" -Recurse -Force
}

# Log errors if any
$error | Out-File -FilePath "C:\Windows\Temp\NinjaRemovalScriptError.txt"
