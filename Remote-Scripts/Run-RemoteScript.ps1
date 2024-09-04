<#PSScriptInfo

.VERSION 1.2

.GUID 5cf7f62e-c134-4826-9ab8-08d04eac6f72

.AUTHOR Kevin

.DESCRIPTION
 Runs a script from a URL in memory

#>

param (
    [Parameter(Mandatory=$true)]
    [string]$ScriptUrl
)

# Download and execute the script directly with basic parsing
try {
    $scriptContent = (Invoke-WebRequest -Uri $ScriptUrl -UseBasicParsing).Content
    Invoke-Expression $scriptContent
} catch {
    Write-Error "Failed to download or execute the script from $ScriptUrl. Error: $_"
}
