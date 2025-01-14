
<#PSScriptInfo

.VERSION 1.1

.GUID 7d3dca0f-727b-4748-ad58-f8dd20af3347

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
 Quick and dirty script to map a network drive and create a desktop shortcut to the mapped drive 

.EXAMPLE
    New-MappedDrive -NetworkPath "\\Server\Share" -Letter "Z" -DriveLabel "MyDrive" 

#> 
# Parameter help description
param (
    [Parameter(Mandatory = $true)]
    [string]$Letter,
    [Parameter(Mandatory = $true)]
    [string]$NetworkPath,
    [Parameter(Mandatory = $true)]
    [string]$DriveLabel,
    [Parameter(Mandatory = $false)]
    [string]$IconPath
    
)

$scriptPath = "$Home\Documents\PowerShell\Scripts"
$windowsPath = "$Home\Documents\windowspowershell\scripts"
$neededScripts = @("Make-MappedDrive", "Make-DesktopShortcut")

# Define the paths where the scripts should be checked
$scriptPath = "$env:USERPROFILE\Documents\WindowsPowerShell\Scripts"
$windowsPath = "$env:WINDIR\System32\WindowsPowerShell\v1.0\Modules"

foreach ($script in $neededScripts) {
    $scriptInstalled = Get-Command -Name $script -ErrorAction SilentlyContinue
    if (-not $scriptInstalled) {
        Install-Script -Name $script -Scope CurrentUser -Force
        Write-Host "$script installed"
    }
    else {
        Write-Host "$script is already installed"
    }
}

Make-MappedDrive -DriveLetter $Letter -FolderPath $NetworkPath -Persist:$true
Make-DesktopShortcut -LinkPath "${Letter}:\\" -LinkName $DriveLabel -IconPath $IconPath



