# Set the terminal window's background and foreground colors

#$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host

# Set the window title
$host.ui.RawUI.WindowTitle = "Kalichuza's PowerShell"

# ASCII Art with pastel colors
$asciiArt = @'
 ____  __.      .__  .__       .__                          
|    |/ _|____  |  | |__| ____ |  |__  __ _______________         ,___, 
|      < \__  \ |  | |  |/ ___\|  |  \|  |  \___   /\__  \        [O.o]
|    |  \ / __ \|  |_|  \  \___|   Y  \  |  //    /  / __ \_      /)  )
|____|__ (____  /____/__|\___  >___|  /____//_____ \(____  /    --"--"--  
        \/    \/             \/     \/            \/     \/     
  
The One, The Only, The PowerShell Owl... 


'@
Write-Host $asciiArt


#Set the Execution Policy 

set-executionPolicy -ExecutionPolicy Bypass -Scope CurrentUser

# Custom Aliases for quick navigation
Set-Alias impmod Import-Module
Set-Alias instmod Install-Module
Set-Alias np Notepad

#Set-Alias code "C:\Program Files\Microsoft VS Code\Code.exe"



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
$modulesToCheck = @("PSReadLine", "Pester", "Regex-Filter", "Regex-Finder")
Install-Modules -Modules $modulesToCheck




# Auto-Import frequently used modules
#Import-Module posh-git
Import-Module PSReadLine

# Custom function to edit this profile quickly
function Edit-Profile {
    code $PROFILE
}

<# Function to get a random quote from the API
# Function to get a random quote from the API
function Get-RandomQuote {
    $apiUrl = "https://api.api-ninjas.com/v1/quotes?category=computers"
    
    # Dont Worry, this is a free api key, do not care one bit if you steal it lol
    $apiKey = "zaIgQT5lhoyNyU+FFRZMsw==E0xqn9sqLneoF9Tz"  # Replace with your actual API key
    Write-Host 'Your Computer Quote: ' -ForegroundColor Magenta
    try {
        $response = Invoke-RestMethod -Uri $apiUrl -Headers @{ "X-Api-Key" = $apiKey } -Method Get
        $quote = $response[0].quote
        $author = $response[0].author

        
        
        Write-Host "`"$quote`" - $author" -ForegroundColor Magenta
    } catch {
        Write-Host "Failed to retrieve a quote. Please check your connection or API key." -ForegroundColor Red
    }
}

# Example usage of the function
Get-RandomQuote
#>

