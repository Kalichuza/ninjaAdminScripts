# Validate LLMNR
Write-Host "Checking LLMNR status..."
$llmnrRegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
if (Test-Path $llmnrRegKey) {
    $llmnrValue = Get-ItemProperty -Path $llmnrRegKey -Name "EnableMulticast" -ErrorAction SilentlyContinue
    if ($llmnrValue.EnableMulticast -eq 0) {
        Write-Host "LLMNR is disabled."
    } else {
        Write-Warning "LLMNR is not disabled."
    }
} else {
    Write-Warning "LLMNR policy not found."
}

# Validate WPAD (WinHttpAutoProxySvc)
Write-Host "Checking WPAD (WinHttpAutoProxySvc) status..."
$wpadRegKey = "HKLM:\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc"
if (Test-Path $wpadRegKey) {
    $wpadValue = Get-ItemProperty -Path $wpadRegKey -Name "Start" -ErrorAction SilentlyContinue
    if ($wpadValue.Start -eq 4) {
        Write-Host "WPAD is disabled."
    } else {
        Write-Warning "WPAD is not disabled."
    }
} else {
    Write-Warning "WPAD service not found."
}

# Validate NetBIOS on all interfaces
Write-Host "Checking NetBIOS status on all interfaces..."
$netbiosRegKey = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces"
if (Test-Path $netbiosRegKey) {
    $netbiosDisabled = $true
    $interfaces = Get-ChildItem $netbiosRegKey

    foreach ($interface in $interfaces) {
        $netbiosValue = Get-ItemProperty -Path "$netbiosRegKey\$($interface.PSChildName)" -Name "NetbiosOptions" -ErrorAction SilentlyContinue
        if ($netbiosValue.NetbiosOptions -ne 2) {
            Write-Warning "NetBIOS is not disabled on interface $($interface.PSChildName)."
            $netbiosDisabled = $false
        }
    }

    if ($netbiosDisabled) {
        Write-Host "NetBIOS is disabled on all interfaces."
    }
} else {
    Write-Warning "NetBIOS configuration not found."
}
