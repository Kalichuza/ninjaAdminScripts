<#PSScriptInfo

.VERSION 1.0

.GUID 3b8904aa-b653-46fd-a7b3-5e72edf3ae6a

.AUTHOR Kalichuza

#>

<# 

.DESCRIPTION 
A simple take on the built-in tool that just works.
#>


# Description:
# This script updates the PSScriptInfo block in a PowerShell script file with a GUID, version, author, and description.

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, HelpMessage="Specify the path of the script to update.")]
    [string]$FilePath,

    [Parameter(Mandatory=$false, HelpMessage="Specify the version number (default is 1.0).")]
    [string]$Version = '1.0',

    [Parameter(Mandatory=$true, HelpMessage="Specify the author of the script.")]
    [string]$Author,

    [Parameter(Mandatory=$true, HelpMessage="Specify the description of the script.")]
    [string]$Description
)

function Add-PSScriptInfo {
    # Generate a new GUID
    $guid = [guid]::NewGuid()

    # Create the PSScriptInfo block
    $psScriptInfo = @"
<#PSScriptInfo

.VERSION $Version

.GUID $guid

.AUTHOR $Author

#>

<# 

.DESCRIPTION 
$Description
#>
"@

    # Read the original script content
    if (Test-Path $FilePath) {
        $originalScript = Get-Content -Path $FilePath -Raw
    } else {
        Write-Error "The file path $FilePath does not exist."
        return
    }

    # Combine PSScriptInfo block with the original script, adding padding space
    $updatedScript = $psScriptInfo + "`r`n`r`n" + $originalScript

    # Save the updated script back to the file
    try {
        Set-Content -Path $FilePath -Value $updatedScript -Force
        Write-Host "Successfully updated the script with PSScriptInfo."
    } catch {
        Write-Error "Failed to update the script. Error: $_"
    }
}

# Run the function to add the PSScriptInfo block
Add-PSScriptInfo
