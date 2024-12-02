[CmdletBinding()]
param (
    [Parameter()]
    [string]$source,

    [Parameter()]
    [string]$destination,

    [Parameter()]
    [string]$logFilePath
)

robocopy $source $destination /E /ETA /R:3 /W:5 /TEE /LOG:$logFilePath /Z