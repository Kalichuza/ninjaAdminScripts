<#PSScriptInfo

.VERSION 1.0

.GUID 9d1ae073-2ca1-4e9b-81c9-2f8186e2b943

.AUTHOR Kalichuza

.PRIVATEDATA

#> 

<# 

.DESCRIPTION 
<#
 This script generates a new GUID and saves it to the clipboard or to a file for later use.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, HelpMessage="Specify a file path to save the GUID")]
    [string]$OutputPath
)

function Generate-Guid {
    # Generate a new GUID
    $guid = [guid]::NewGuid()

    # Display the GUID to the console
    Write-Host "Generated GUID: $guid"

    # Copy the GUID to the clipboard
    $guid | Set-Clipboard
    Write-Host "GUID copied to clipboard."

    # Save the GUID to a file if OutputPath is provided
    if ($OutputPath) {
        try {
            $guid | Out-File -FilePath $OutputPath -Force
            Write-Host "GUID saved to file: $OutputPath"
        }
        catch {
            Write-Error "Failed to save the GUID to the file. Error: $_"
        }
    }
}

# Run the function
Generate-Guid
