param (
    [string]$MappedDriveLetter
)
function Open-mappedDrive {
   
    $Shell = New-Object -ComObject "Shell.Application"
    $Shell.Explore("${MappedDriveLetter}:\")
    Write-Host "Opening ${MappedDriveLetter}"
}

Open-mappedDrive 