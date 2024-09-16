
<#PSScriptInfo

.VERSION 1.0.1

.GUID cfe55a59-f828-4724-bd2c-1d584f443f10

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
 One click PWSH Core GPO Env setup 

#> 
# Check if the files have been downloaded
if ((Test-Path "$($env:USERPROFILE)\Desktop\PowerShellCoreExecutionPolicy.admx") -and (Test-Path "$($env:USERPROFILE)\Desktop\PowerShellCoreExecutionPolicy.adml")) {
    
    # Ensure the destination directories exist
    if (-not (Test-Path "C:\Windows\PolicyDefinitions")) {
        Write-Error "PolicyDefinitions folder not found!"
        exit
    }

    if (-not (Test-Path "C:\Windows\PolicyDefinitions\en-US")) {
        Write-Error "Language folder (en-US) not found!"
        exit
    }

    # Move ADMX and ADML files to the appropriate locations
    Move-Item "$($env:USERPROFILE)\Desktop\PowerShellCoreExecutionPolicy.admx" "C:\Windows\PolicyDefinitions\PowerShellCoreExecutionPolicy.admx" -Force
    Move-Item "$($env:USERPROFILE)\Desktop\PowerShellCoreExecutionPolicy.adml" "C:\Windows\PolicyDefinitions\en-US\PowerShellCoreExecutionPolicy.adml" -Force

    Write-Host "ADMX and ADML files have been moved successfully to the correct directories."
} else {
    Write-Error "One or both files were not downloaded successfully."
}
