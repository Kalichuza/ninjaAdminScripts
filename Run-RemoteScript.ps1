param (
    [Parameter(Mandatory=$true)]
    [string]$ScriptUrl
)

# Download and execute the script directly
Invoke-Expression (Invoke-WebRequest -Uri $ScriptUrl).Content
