# Import the Active Directory module
Import-Module ActiveDirectory

# Get a list of all computer names in the domain
$computers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name

# Create log arrays for skipped computers
$skippedOffline = @()
$skippedRestart = @()

# Function to check and install the PSWindowsUpdate module
function Ensure-PSWindowsUpdateInstalled {
    param (
        [string]$ComputerName
    )
    try {
        Write-Host "Checking if PSWindowsUpdate module is installed on $ComputerName" -ForegroundColor Cyan
        $isInstalled = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            Get-Module -Name PSWindowsUpdate -ListAvailable
        } -ErrorAction Stop

        if ($isInstalled) {
            Write-Host "PSWindowsUpdate module is already installed on $ComputerName" -ForegroundColor Green
        } else {
            Write-Host "PSWindowsUpdate module not found on $ComputerName. Installing..." -ForegroundColor Yellow
            Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
            } -ErrorAction Stop
            Write-Host "PSWindowsUpdate module successfully installed on $ComputerName" -ForegroundColor Green
        }
    } catch {
        Write-Host "Failed to check or install PSWindowsUpdate module on $ComputerName. Error: $_" -ForegroundColor Red
        throw
    }
}

# Function to check if a restart is required
function Check-RestartRequired {
    param (
        [string]$ComputerName
    )
    try {
        $needsRestart = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
        } -ErrorAction Stop

        return $needsRestart
    } catch {
        Write-Host "Failed to check restart requirement on $ComputerName. Error: $_" -ForegroundColor Red
        throw
    }
}

# Function to restart a computer
function Restart-ComputerIfNeeded {
    param (
        [string]$ComputerName
    )
    try {
        Write-Host "Restarting $ComputerName as it requires a restart." -ForegroundColor Yellow
        Restart-Computer -ComputerName $ComputerName -Force -Wait -For PowerShell -Timeout 300 -ErrorAction Stop
        Write-Host "$ComputerName has been restarted successfully." -ForegroundColor Green
    } catch {
        Write-Host "Failed to restart $ComputerName. Error: $_" -ForegroundColor Red
        throw
    }
}

# Function to install updates on a computer
function Install-Updates {
    param (
        [string]$ComputerName
    )
    try {
        Write-Host "Installing updates on $ComputerName" -ForegroundColor Green
        Invoke-Command -ComputerName $ComputerName -ScriptBlock {
            Install-WindowsUpdate -AcceptAll -ForceDownload -ForceInstall -AutoReboot
        } -ErrorAction Stop
        Write-Host "Updates successfully installed on $ComputerName" -ForegroundColor Green
    } catch {
        Write-Host "Failed to install updates on $ComputerName. Error: $_" -ForegroundColor Red
        throw
    }
}

# Main script loop
foreach ($computer in $computers) {
    try {
        # Check if the computer is reachable
        if (Test-Connection -ComputerName $computer -Count 1 -Quiet) {
            Write-Host "$computer is online." -ForegroundColor Cyan

            # Check if a restart is required
            if (Check-RestartRequired -ComputerName $computer) {
                # Restart the computer and skip updates
                Restart-ComputerIfNeeded -ComputerName $computer
                Write-Host "Skipping updates on $computer due to pending restart." -ForegroundColor Yellow
                $skippedRestart += $computer
                continue
            }

            # Ensure the PSWindowsUpdate module is installed
            Ensure-PSWindowsUpdateInstalled -ComputerName $computer

            # Install updates on the computer
            Install-Updates -ComputerName $computer
        } else {
            Write-Host "$computer is offline. Skipping..." -ForegroundColor Yellow
            $skippedOffline += $computer
        }
    } catch {
        Write-Host "An unexpected error occurred while processing $computer. Error: $_" -ForegroundColor Red
    }
}

# Log skipped computers
Write-Host "The following computers were skipped due to being offline:" -ForegroundColor Yellow
$skippedOffline | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }

Write-Host "The following computers were skipped due to pending restarts:" -ForegroundColor Yellow
$skippedRestart | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }

Write-Host "Update process completed for all computers." -ForegroundColor Green
