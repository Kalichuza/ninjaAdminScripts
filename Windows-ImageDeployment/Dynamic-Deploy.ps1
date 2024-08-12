Write-Host -ForegroundColor Green "Starting OSDCloud ZTI"
Start-Sleep -Seconds 5

# Prompt user for OS selection
$osChoice = Read-Host "Enter the OS Version to install (Windows 10/Windows 11):"

# Validate the user's choice and start the deployment
if ($osChoice -eq '10') {
    Start-OSDCloud -OSVersion 'Windows 10' -OSBuild 22H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail -ZTI
} elseif ($osChoice -eq '11') {
    Start-OSDCloud -OSVersion 'Windows 11' -OSBuild 22H2 -OSEdition Pro -OSLanguage en-us -OSLicense Retail -ZTI
} else {
    Write-Host -ForegroundColor Red "Invalid selection. Please run the script again."
    Exit
}

# Restart from WinPE after installation
Write-Host -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
