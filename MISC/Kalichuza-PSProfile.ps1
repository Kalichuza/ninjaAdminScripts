# Set the window title to something unique
$host.ui.RawUI.WindowTitle = "Kalichuza's PowerShell"

# ASCII Art with pastel colors
$asciiArt = @"
 ____  __.      .__  .__       .__                          
|    |/ _|____  |  | |__| ____ |  |__  __ _______________   
|      < \__  \ |  | |  |/ ___\|  |  \|  |  \___   /\__  \  
|    |  \ / __ \|  |_|  \  \___|   Y  \  |  //    /  / __ \_
|____|__ (____  /____/__|\___  >___|  /____//_____ \(____  /
        \/    \/             \/     \/            \/     \/ 
"@
Write-Host $asciiArt -ForegroundColor Cyan

# Set a pastel-themed color scheme
$Host.UI.RawUI.BackgroundColor = "DarkGray"
$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host

# Custom Aliases for quick navigation
Set-Alias docs Set-Location -Value "$HOME\Documents"
Set-Alias proj Set-Location -Value "$HOME\Projects"
Set-Alias dl Set-Location -Value "$HOME\Downloads"
Set-Alias np Notepad
Set-Alias code "C:\Program Files\Microsoft VS Code\Code.exe"

# Personalized prompt with Git branch display and a light pastel color
function prompt {
    $gitBranch = ''
    if (Test-Path .git) {
        $branch = git rev-parse --abbrev-ref HEAD
        $gitBranch = " [$branch]"
    }
    $pathColor = "Cyan"
    $branchColor = "Magenta"
    Write-Host "$($PWD.Path)$gitBranch>" -NoNewline -ForegroundColor $pathColor
    return " "
}

# Auto-Import frequently used modules
Import-Module posh-git
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
    $quotes | Get-Random
}
Write-Host (Get-RandomQuote) -ForegroundColor Magenta
