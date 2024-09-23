[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)]
    [string]$OutputPath,

    [Parameter(Mandatory=$false)]
    [hashtable]$ExpectedAccounts = @{}
)

function Get-SuspiciousEntries {
    param (
        [string]$privilege,
        [string[]]$accounts
    )
    
    $suspiciousFlags = @()

    # Define suspicious SIDs and accounts (default baseline)
    $baselineSuspiciousAccounts = @("Guest", "S-1-5-32-546", "S-1-5-32-547")

    # Check for accounts that are unexpected or should not have specific privileges
    foreach ($account in $accounts) {
        if ($baselineSuspiciousAccounts -contains $account -or
            ($ExpectedAccounts[$privilege] -and -not ($ExpectedAccounts[$privilege] -contains $account))) {
            $suspiciousFlags += "Suspicious Account: $account"
        }
    }

    return $suspiciousFlags
}

function Generate-SecurityReport {
    [string]$report = "Security Report:`n"
    
    $filePath = "$Env:TEMP\secedit.txt"
    
    if (-not (Test-Path -Path $filePath)) {
        Write-Error "File not found: $filePath"
        return
    }

    $lines = Get-Content -Path $filePath
    foreach ($line in $lines) {
        if ($line -match "^Se.*") {
            $privilege, $accountList = $line -split ' = '
            $accounts = $accountList -split ","
            $accounts = $accounts -replace "\*", ""  # Remove the '*' prefix from SIDs

            $suspiciousEntries = Get-SuspiciousEntries -privilege $privilege -accounts $accounts
            if ($suspiciousEntries.Count -gt 0) {
                $report += "Suspicious Entry Found for ${privilege}:`n"
                foreach ($flag in $suspiciousEntries) {
                    $report += "- $flag`n"
                }
            }
        }
    }

    $report += "`nEnd of Report"
    return $report
}

function Analyze-SecurityConfiguration {
    $filePath = "$Env:TEMP\secedit.txt"

    # Export the security configuration to a file
    Write-Output "Exporting security configuration..."
    & SecEdit.exe /export /areas USER_RIGHTS /cfg $filePath

    # Generate the security report
    $securityReport = Generate-SecurityReport

    # Output the report
    if ($OutputPath) {
        Write-Output "Writing security report to file: $OutputPath"
        $securityReport | Out-File -FilePath $OutputPath -Encoding UTF8
    } else {
        Write-Output $securityReport
    }

    # Clean up the temporary file
    if (Test-Path -Path $filePath) {
        Write-Output "Deleting temporary file..."
        Remove-Item -Path $filePath -Force
    }
}

# Run the analysis
Analyze-SecurityConfiguration
