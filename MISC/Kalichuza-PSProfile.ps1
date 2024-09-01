# Set the terminal window's background and foreground colors

#$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host

# Set the window title
$host.ui.RawUI.WindowTitle = "Kalichuza's PowerShell"

# ASCII Art with pastel colors
$asciiArt = @'
 
The One, The Only, The PowerShell Owl...

 ____  ___      .__  .__       .__                          
|    |/ _|____  |  | |__| ____ |  |__  __ _______________         ,___, 
|      < \__  \ |  | |  |/ ___\|  |  \|  |  \___   /\__  \        [O.o]
|    |  \ / __ \|  |_|  \  \___|   Y  \  |  //    /  / __ \_      /)  )
|____|__ (____  /____/__|\___  >___|  /____//_____ \(____  /    --"--"--  
        \/    \/             \/     \/            \/     \/ 
    
'@
Write-Host $asciiArt


#Set the Execution Policy 

set-executionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

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

}

foreach ($alias in $aliases.GetEnumerator()) {
    Set-Alias -Name $alias.Key -Value $alias.Value

}
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
#Set-Alias code "C:\Program Files\Microsoft VS Code\Code.exe"



# Auto-Install and Import Modules
function Install-Modules {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Modules
    )

    foreach ($module in $Modules) {
        if (Get-Module -ListAvailable -Name $module) {
            Write-Host "$module is already installed." -ForegroundColor Green
            Import-Module -Name $module -Force
        }
        else {
            Write-Host "Installing $module..." -ForegroundColor Yellow
            Install-Module -Name $module -Force -Scope CurrentUser
            if (Get-Module -ListAvailable -Name $module) {
                Write-Host "$module has been successfully installed." -ForegroundColor Green
                Import-Module -Name $module -Force 
            }
            else {
                Write-Host "Failed to install $module." -ForegroundColor Red
            }
        }
    }
}

# Example usage:
$modulesToCheck = @("PSReadLine", "Pester", "Regex-Filter", "Regex-Finder")
Install-Modules -Modules $modulesToCheck




# Auto-Import frequently used modules
#Import-Module posh-git
Import-Module PSReadLine

# Custom function to edit this profile quickly
function Edit-Profile {
    code $PROFILE
}
# Set the terminal window's background and foreground colors  
