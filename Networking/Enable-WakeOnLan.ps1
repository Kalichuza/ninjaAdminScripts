[CmdletBinding()]
param (
    [switch]$EnableMagicPacket = $true
)

function Enable-WakeOnLan {
    param (
        [string]$AdapterName
    )

    Write-Host "Enabling Wake-on-LAN on adapter: $AdapterName"

    $powerManagementSettings = Get-NetAdapterPowerManagement -Name $AdapterName

    if ($powerManagementSettings) {
        # Enable Wake on Magic Packet
        Set-NetAdapterPowerManagement -Name $AdapterName -WakeOnMagicPacket Enabled

        Write-Host "Wake-on-LAN enabled for adapter: $AdapterName"
    } else {
        Write-Warning "Power management settings not found for adapter: $AdapterName"
    }
}

# Get all active network adapters
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

foreach ($adapter in $adapters) {
    Enable-WakeOnLan -AdapterName $adapter.Name
}

Write-Output "Wake-on-LAN has been configured for all active adapters."
