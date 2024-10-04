# Display the timestamp of the snapshot
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Write-Host "==== Snapshot of Security Configurations ===="
Write-Host "Timestamp: $timestamp"
Write-Host "============================================"

# Snapshot and Validate LLMNR
Write-Host "Checking LLMNR status..."
$llmnrRegKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient"
if (Test-Path $llmnrRegKey) {
    $llmnrValue = Get-ItemProperty -Path $llmnrRegKey -Name "EnableMulticast" -ErrorAction SilentlyContinue
    $currentLLMNR = $llmnrValue.EnableMulticast
    Write-Host "LLMNR (EnableMulticast) current value: $currentLLMNR"
    
    if ($currentLLMNR -eq 0) {
        Write-Host "LLMNR is already disabled."
    } else {
        Write-Host "LLMNR is enabled. Disabling it..."
        Set-ItemProperty -Path $llmnrRegKey -Name "EnableMulticast" -Value 0
        Write-Host "LLMNR has been disabled."
    }
} else {
    Write-Warning "LLMNR policy not found. Creating registry key and disabling LLMNR..."
    New-Item -Path $llmnrRegKey -Force
    Set-ItemProperty -Path $llmnrRegKey -Name "EnableMulticast" -Value 0
    Write-Host "LLMNR (EnableMulticast) was not found. Set to disabled."
}

# Snapshot and Validate WPAD (WinHttpAutoProxySvc)
Write-Host "Checking WPAD (WinHttpAutoProxySvc) status..."
$wpadRegKey = "HKLM:\SYSTEM\CurrentControlSet\Services\WinHttpAutoProxySvc"
if (Test-Path $wpadRegKey) {
    $wpadValue = Get-ItemProperty -Path $wpadRegKey -Name "Start" -ErrorAction SilentlyContinue
    $currentWPAD = $wpadValue.Start
    Write-Host "WPAD (WinHttpAutoProxySvc Start) current value: $currentWPAD"
    
    if ($currentWPAD -eq 4) {
        Write-Host "WPAD is already disabled."
    } else {
        Write-Host "WPAD is enabled. Disabling it..."
        Set-ItemProperty -Path $wpadRegKey -Name "Start" -Value 4
        Write-Host "WPAD has been disabled."
    }
} else {
    Write-Warning "WPAD service not found."
}

# Snapshot and Validate NetBIOS on all interfaces
Write-Host "Checking NetBIOS status on all interfaces..."
$netbiosRegKey = "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters\Interfaces"
if (Test-Path $netbiosRegKey) {
    $netbiosDisabled = $true
    $interfaces = Get-ChildItem $netbiosRegKey

    foreach ($interface in $interfaces) {
        $netbiosValue = Get-ItemProperty -Path "$netbiosRegKey\$($interface.PSChildName)" -Name "NetbiosOptions" -ErrorAction SilentlyContinue
        $currentNetBIOS = $netbiosValue.NetbiosOptions
        Write-Host "NetBIOS (Interface $($interface.PSChildName)) current value: $currentNetBIOS"
        
        if ($currentNetBIOS -ne 2) {
            Write-Host "NetBIOS is enabled on interface $($interface.PSChildName). Disabling it..."
            Set-ItemProperty -Path "$netbiosRegKey\$($interface.PSChildName)" -Name "NetbiosOptions" -Value 2
            Write-Host "NetBIOS has been disabled on interface $($interface.PSChildName)."
        }
    }
} else {
    Write-Warning "NetBIOS configuration not found."
}

Write-Host "Security configuration changes applied."
