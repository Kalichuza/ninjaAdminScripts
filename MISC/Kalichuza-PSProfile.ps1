Clear-Host

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
    "rbf"     = "Remove-Item -Recurse -Force"
    "scat"    = "Set-Content"
    "dircpy"  = "Copy-Item -Recurse -Force"
    "dirmv"   = "Move-Item -Recurse -Force" 

}

$aliases = $aliases | Sort-Object -Property 'Name'

foreach ($alias in $aliases.GetEnumerator()) {
    Set-Alias -Name $alias.Key -Value $alias.Value
    write-host "$($alias.Value) is now $($alias.Key)" -ForegroundColor Cyan

}
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

$modulesToCheck = @("PSReadLine", "Pester", "Regex-Filter", "Regex-Finder")
Install-Modules -Modules $modulesToCheck


Write-Host "  `n - - - - - - - - - - - - - - - - `n  "

Write-Host "The One, The Only, The PowerShell Owl...`n" -ForegroundColor Darkred

Write-Host $asciiArt -ForegroundColor DarkRed

Write-Host "  `n - - - - - - - - - - - - - - - - `n  "

$date = Get-Date 

Write-Host "Today is $date" -ForegroundColor DarkYellow

Write-Host "  `n - - - - - - - - - - - - - - - - `n  "
  
