
<#PSScriptInfo

.VERSION 1.1

.GUID c535164d-b299-47f0-9c30-3c3136d8ac40

.DESCRIPTION Pulls scripts needed to setup Laps and PWSH core GPO 


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


function Load-CustomScripts {
    # Define the list of scripts to check and install
    $scripts = @("Find-LocalUsers", 
        "Get-ComputerOU", 
        "Move-ADObjects", 
        "Set-PwshFolderPermissions",
        "Find-ExposedPasswords",
        "Set-LapsFolderPM",
        "Setup-PWSHCoreGPO.ps1"

    )
 
    # Check if each script is installed
    foreach ($script in $scripts) {
        $installedScript = Get-Command -Name $script -ErrorAction SilentlyContinue
 
        if ($installedScript) {
            Write-Host "$script is already installed." -ForegroundColor Green
        }
        else {
            Write-Host "$script is not installed. Installing now..." -ForegroundColor Yellow
            Install-Script -Name $script -Force -Scope CurrentUser
            Write-Host "$script installation completed." -ForegroundColor Green
        }
    }
}
Load-CustomScripts

