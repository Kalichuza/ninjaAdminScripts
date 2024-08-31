$host.ui.RawUI.WindowTitle = "MCS SHELL"

$asciiArt = @'

   Hello, how can we hack you today? 

      ___           ___           ___              
     /\  \         /\__\         /\__\             
    |::\  \       /:/  /        /:/ _/_            
    |:|:\  \     /:/  /        /:/ /\  \           
  __|:|\:\  \   /:/  /  ___   /:/ /::\  \          
 /::::|_\:\__\ /:/__/  /\__\ /:/_/:/\:\__\         
 \:\~~\  \/__/ \:\  \ /:/  / \:\/:/ /:/  /         
  \:\  \        \:\  /:/  /   \::/ /:/  /          
   \:\  \        \:\/:/  /     \/_/:/  /           
    \:\__\        \::/  /        /:/  /            
     \/__/         \/__/         \/__/             

'@

Write-Host $asciiArt -ForegroundColor Cyan

function Edit-Profile {
  code $PROFILE
  
}

# Custom Aliases for quick navigation
Set-Alias impmod Import-Module
Set-Alias instmod Install-Module
Set-Alias np Notepad
Set-Alias gcmd Get-Command
Set-Alias gmod Get-Module
Set-Alias ie Invoke-Expression
Set-Alias psd Get-PSDrive


# Auto-Install and Import Modules
function Install-Modules {
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$Modules
    )

    foreach ($module in $Modules) {
        if (Get-Module -ListAvailable -Name $module) {
            Write-Host "$module is already installed." -ForegroundColor Green
            Import-Module -Name $module -Force
        } else {
            Write-Host "Installing $module..." -ForegroundColor Yellow
            Install-Module -Name $module -Force -Scope CurrentUser
            if (Get-Module -ListAvailable -Name $module) {
                Write-Host "$module has been successfully installed." -ForegroundColor Green
                Import-Module -Name $module -Force 
            } else {
                Write-Host "Failed to install $module." -ForegroundColor Red
            }
        }
    }
}

# Example usage:
$modulesToCheck = @("PSReadLine", "Pester", "Regex-Filter", "Regex-Finder","PSPGP")
Install-Modules -Modules $modulesToCheck
