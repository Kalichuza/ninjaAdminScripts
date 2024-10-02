# Disable LLMNR
Write-Host "Disabling LLMNR..."
$llmnrRegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
if (-not (Test-Path $llmnrRegKey)) {
    New-Item -Path $llmnrRegKey -Force
}
Set-ItemProperty -Path $llmnrRegKey -Name "EnableMulticast" -Value 0

# Validate LLMNR
$llmnrValue = Get-ItemProperty -Path $llmnrRegKey -Name "EnableMulticast"
if ($llmnrValue.EnableMulticast -eq 0) {
    Write-Host "LLMNR Disabled successfully."
} else {
    Write-Warning "Failed to disable LLMNR."
}

# Disable WPAD by setting WinHttpAutoProxySvc to '4' (Disabled)
Write-Host "Disabling WPAD..."
$wpadRegKey = "HKLM:\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc"
Set-ItemProperty -Path $wpadRegKey -Name "Start" -Value 4

# Validate WPAD
$wpadValue = Get-ItemProperty -Path $wpadRegKey -Name "Start"
if ($wpadValue.Start -eq 4) {
    Write-Host "WPAD Disabled successfully."
} else {
    Write-Warning "Failed to disable WPAD."
}

# Disable NetBIOS for all network interfaces
Write-Host "Disabling NetBIOS on all interfaces..."
$netbiosRegKey = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces"
$interfaces = Get-ChildItem $netbiosRegKey

foreach ($interface in $interfaces) {
    Set-ItemProperty -Path "$netbiosRegKey\$($interface.PSChildName)" -Name "NetbiosOptions" -Value 2

    # Validate NetBIOS for each interface
    $netbiosValue = Get-ItemProperty -Path "$netbiosRegKey\$($interface.PSChildName)" -Name "NetbiosOptions"
    if ($netbiosValue.NetbiosOptions -eq 2) {
        Write-Host "NetBIOS disabled for interface $($interface.PSChildName)."
    } else {
        Write-Warning "Failed to disable NetBIOS for interface $($interface.PSChildName)."
    }
}

Write-Host "All tasks completed."
