[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$ScriptUrl,

    [Parameter(Mandatory=$false)]
    [string[]]$ScriptParameters
)

# Download and execute the script directly with basic parsing
try {
    $scriptContent = (Invoke-WebRequest -Uri $ScriptUrl -UseBasicParsing).Content
    $scriptBlock = [ScriptBlock]::Create($scriptContent)
    
    # Invoke the script block with parameters if provided
    if ($ScriptParameters) {
        & $scriptBlock @ScriptParameters
    } else {
        & $scriptBlock
    }

} catch {
    Write-Error "Failed to download or execute the script from $ScriptUrl. Error: $_"
}
