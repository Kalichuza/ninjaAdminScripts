<#
.SYNOPSIS
    Changes the Windows product key.

.DESCRIPTION
    This script changes the Windows product key using the provided product key.

.PARAMETER ProductKey
    The new Windows product key to be installed.

.EXAMPLE
    .\Change-WindowsProductKey.ps1 -ProductKey "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX"
    Changes the Windows product key to the specified key.

.NOTES
    Author: [Your Name]
    Date: [Date]
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, HelpMessage="The new Windows product key to be installed.")]
    [ValidatePattern("^[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}$")]
    [string]$ProductKey
)

function Change-WindowsProductKey {
    param (
        [string]$ProductKey
    )
    try {
        $result = (slmgr.vbs -ipk $ProductKey)
        Write-Output "Product key change result: $result"
        $activationResult = (slmgr.vbs -ato)
        Write-Output "Activation result: $activationResult"
    }
    catch {
        Write-Error "Failed to change product key. Error: $_"
    }
}

Change-WindowsProductKey -ProductKey $ProductKey
