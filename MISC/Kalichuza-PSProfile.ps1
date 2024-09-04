Clear-Host
Write-Host "  `n - - - - - - - - - - - - - - - - `n  "
# Set the window title
$host.ui.RawUI.WindowTitle = "Kalichuza's PowerShell"



$asciiArt = @'
 ____  ___      .__  .__       .__                          
|    |/ _|____  |  | |__| ____ |  |__  __ _______________         ,___, 
|      < \__  \ |  | |  |/ ___\|  |  \|  |  \___   /\__  \        [O.o]
|    |  \ / __ \|  |_|  \  \___|   Y  \  |  //    /  / __ \_      /)  )
|____|__ (____  /____/__|\___  >___|  /____//_____ \(____  /    --"--"--  
        \/    \/             \/     \/            \/     \/ 
    
'@


#Set multipe aliases from and hashtable
$aliases = @{
    "gmod"    = "Get-Module"
    "ie"      = "Invoke-Expression"
    "psd"     = "Get-PSDrive"
    "impmod"  = "Import-Module"
    "instmod" = "Install-Module"
    "np"      = "Notepad"
    "gcmd"    = "Get-Command"
    "rmod"    = "Remove-Module"
    "ga"      = "Get-Alias"
    "scat"    = "Set-Content"

}

$aliases = $aliases | Sort-Object -Property 'Name'

foreach ($alias in $aliases.GetEnumerator()) {
    Set-Alias -Name $alias.Key -Value $alias.Value
    #write-host "$($alias.Value) is now $($alias.Key)" -ForegroundColor Cyan
  

}
$aliases = $aliases | Sort-Object -Property 'Name'

#list Custom Aliases
function Get-Aliases {
    $aliases.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key) -> $($_.Value)" -ForegroundColor Cyan
        Start-Sleep -Milliseconds 100
    }
}

Get-Aliases 


Write-Host "  `n - - - - - - - - - - - - - - - - `n  "
function Load-CustomScripts {
    $scripts = @("Get-RemoteScript", "Run-RemoteScript")
    foreach($script in $scripts) {
        Install-Script -Name $script -Force -Scope CurrentUser
        write-host "Installing $script..." -ForegroundColor Yellow
    }
}
Load-CustomScripts

Write-Host "  `n - - - - - - - - - - - - - - - - `n  "
function HomeBase {
    Set-Location $env:USERPROFILE
    
}
function Open-Desktop {
    Set-Location "$env:USERPROFILE\Desktop"
    
}
function Open-Downloads {
    Set-Location "$env:USERPROFILE\Downloads"        
    
}
function Invoke-Profile {
    . $PROFILE
}
function Edit-Profile {
    code $PROFILE
}

function Get-Disks {
    wmic diskdrive list brief

}
Start-Sleep -Milliseconds 100
# Auto-Install and Import Modules
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

$modulesToCheck = @(
    "PSReadLine", 
    "Pester",
    "Regex-Filter", 
    "Regex-Finder", 
    "PSScriptTools", 
    "PSScriptAnalyzer", 
    "PSPGP" 
    "7Zip4Powershell",
    "PSWriteHTML",
    "PSWriteColor",
    "PSWinDocumentation",
    "PSEventViewer",
    "PSWindowsUpdate"

)

Install-Modules -Modules $modulesToCheck


Write-Host "  `n - - - - - - - - - - - - - - - - `n  "

Write-Host "The One, The Only, The PowerShell Owl...`n" -ForegroundColor Darkred
Start-Sleep -Milliseconds 100
Write-Host $asciiArt -ForegroundColor DarkRed
Start-Sleep -Milliseconds 100
Write-Host "  `n - - - - - - - - - - - - - - - - `n  "
Start-Sleep -Milliseconds 200
$date = Get-Date 
Start-Sleep -Milliseconds 100
Write-Host "Today is $date" -ForegroundColor DarkYellow
Start-Sleep -Milliseconds 100
Write-Host "  `n - - - - - - - - - - - - - - - - `n  "
  

