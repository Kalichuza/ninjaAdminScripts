<#
.SYNOPSIS
    This script checks if the RSAT Active Directory module is installed and installs it if it is not.

.DESCRIPTION
    The script retrieves the state of the RSAT Active Directory module and displays its current state. If the module is not installed, the script will install it.

.EXAMPLE
    .\Install-ADModule.ps1
    This command checks if the RSAT Active Directory module is installed. If it is not installed, the script will install it.

#>

# Check to see if the module is installed
$moduleInstalled = Get-WindowsCapability -Name RSAT.ActiveDirectory* -Online | Select-Object -Property Name,State

# Display the current state of the module
Write-Host "Module State: " $moduleInstalled

# Install the module if it is not installed
if ($moduleInstalled.State -eq "NotPresent") {
    Write-Host $moduleInstalled.Name "is not installed, installing it now..."
    Add-WindowsCapability -Online -Name $moduleInstalled.Name
    Write-Host "Done!"
} else {
    Write-Host $moduleInstalled.Name "is already installed!"
}
