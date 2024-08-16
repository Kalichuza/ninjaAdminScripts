Write-Host -ForegroundColor Green "Starting OSDCloud ZTI for Windows Server 2022 Datacenter"
Start-Sleep -Seconds 5

# Start the deployment with Windows Server 2022 Datacenter edition
Start-OSDCloud -OSVersion 'Windows Server 2022' -OSBuild 21H2 -OSEdition 'Datacenter' -OSLanguage en-us -OSLicense Volume -ZTI

# Restart from WinPE
Write-Host -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20

wpeutil reboot
