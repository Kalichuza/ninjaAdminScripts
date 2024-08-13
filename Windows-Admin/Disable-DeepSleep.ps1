function Disable-DeepSleep {
    param (
        [string]$AdapterName
    )

    Write-Host "Disabling deep sleep on adapter: $AdapterName"

    try {
        # Set the advanced property to disable low power states (if available)
        Set-NetAdapterAdvancedProperty -Name $AdapterName -DisplayName "Energy Efficient Ethernet" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $AdapterName -DisplayName "Reduce link speed during standby" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        Set-NetAdapterAdvancedProperty -Name $AdapterName -DisplayName "Shutdown Wake-on-LAN" -DisplayValue "Disabled" -ErrorAction SilentlyContinue
        
        Write-Host "Deep sleep disabled for adapter: $AdapterName"
    } catch {
        Write-Warning "Could not disable deep sleep on adapter: $AdapterName. Error: $_"
    }
}

# Get all active network adapters
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }

foreach ($adapter in $adapters) {
    Disable-DeepSleep -AdapterName $adapter.Name
}

Write-Output "Deep sleep has been disabled for all active adapters (if applicable)."
