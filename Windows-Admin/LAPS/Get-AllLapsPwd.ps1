
<#PSScriptInfo

.VERSION 1.2

.GUID 63ea57e6-7f65-4423-935b-1c7e8bfde5cc

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
 list all Laps passwords 

#> 
Param(
    [string]$OU
)

$modulesToImport = @('ActiveDirectory', 'AdmPwd.PS')

function Install-Modules {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Modules
    )

    foreach ($module in $Modules) {
        if (Get-Module -ListAvailable -Name $module) {
            Write-Host "$module is already installed." -ForegroundColor DarkCyan
            Import-Module -Name $module -Force
            Start-Sleep -Milliseconds 100
        }
        else {
            Write-Host "Installing $module..." -ForegroundColor Yellow
            Install-Module -Name $module -Force -Scope CurrentUser
            if (Get-Module -ListAvailable -Name $module) {
                Write-Host "$module has been successfully installed." -ForegroundColor DarkMagenta
                Import-Module -Name $module -Force 
            }
            else {
                Write-Host "Failed to install $module." -ForegroundColor Red
            }
        }
    }
}

Install-Modules -Modules $modulesToImport

$computers = Get-ADComputer -Filter * | Where-Object { $_.DistinguishedName -like "*$OU*" }

foreach ($computer in $computers) {
    $computerName = $computer.Name
    $LapsPwd = Get-AdmPwdPassword -ComputerName $computerName
    $LapsPwd
}
