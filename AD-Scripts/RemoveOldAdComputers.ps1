[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$Year,

    [Parameter(Mandatory=$false)]
    [string]$Month,

    [Parameter(Mandatory=$true)]
    [string]$OU,

    [Parameter(Mandatory=$false)]
    [switch]$Delete
)

function Load-CustomScripts {
    # Define the list of scripts to check and install
    $scripts = @("List-ADComputersByLastLogon")

    # Check if each script is installed
    foreach ($script in $scripts) {
        $installedScript = Get-Command -Name $script -ErrorAction SilentlyContinue

        if ($installedScript) {
            Write-Host "$script is already installed." -ForegroundColor Green
        }
        else {
            Write-Host "$script is not installed. Installing now..." -ForegroundColor Yellow
            Install-Script -Name $script -Force -Scope CurrentUser
            Write-Host "$script installation completed." -ForegroundColor Green
        }
    }
}

function List-And-Delete-ADComputers {
    # List AD Computers by Last Logon
    $computers = List-ADComputersByLastLogon

    if ($Year -and $Month) {
        # Filter the computers by the specified year and month
        $oldComputers = $computers | Where-Object { $_.LastLogon -like "*$Month/$Year*" }
    }
    elseif ($Year) {
        # Filter the computers by the specified year
        $oldComputers = $computers | Where-Object { $_.LastLogon -like "*$Year*" }
    }
    else {
        # If no year is specified, just list all computers
        $oldComputers = $computers
    }

    # Output the list of computers
    $oldComputers | Format-Table -Property ComputerName, LastLogon

    if ($Delete.IsPresent) {
        foreach ($name in $oldComputers.ComputerName) {
            $pName = "CN=$name,$OU"
            Write-Host "$pName has been removed" -ForegroundColor Red
            Remove-ADComputer -Identity $pName -Confirm:$false
        }
    }
}

# Load the custom scripts
Load-CustomScripts

# List and optionally delete computers based on the provided parameters
List-And-Delete-ADComputers
