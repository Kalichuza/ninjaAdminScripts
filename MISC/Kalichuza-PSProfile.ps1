# Set the terminal window's background and foreground colors

$Host.UI.RawUI.ForegroundColor = "White"
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
  
The One, The Only, The Powershell Owl... 


'@
Write-Host $asciiArt

# Custom Aliases for quick navigation
Set-Alias impmod Import-Module
Set-Alias instmod Install-Module
Set-Alias docs Set-Location
Set-Alias proj Set-Location
Set-Alias dl Set-Location
Set-Alias np Notepad
Set-Alias code "C:\Program Files\Microsoft VS Code\Code.exe"

# Personalized prompt with Git branch display and a light pastel color
function prompt {
    $gitBranch = ''
    if (Test-Path .git) {
        $branch = git rev-parse --abbrev-ref HEAD
        $gitBranch = " [$branch]"
    }
    Write-Host "$($PWD.Path)$gitBranch>" -NoNewline
    return " "
}

# Auto-Import frequently used modules
#Import-Module posh-git
Import-Module PSReadLine

# Custom function to edit this profile quickly
function Edit-Profile {
    notepad $PROFILE
}

# Display a random motivational quote each time PowerShell starts
function Get-RandomQuote {
    $quotes = @(
        "Do or do not, there is no try. - Yoda",
        "Stay hungry, stay foolish. - Steve Jobs",
        "The only limit to our realization of tomorrow is our doubts of today. - Franklin D. Roosevelt"
    )
    $quote = $quotes | Get-Random
    Write-Host $quote
}
