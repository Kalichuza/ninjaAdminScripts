<#
.SYNOPSIS
Decodes generic access mappings for various NT object types retrieved via Get-NTType into readable standard and generic rights.

.DESCRIPTION
This script retrieves NT object types and their generic mappings (R, W, E, A) from the `Get-NTType` command.
The `Get-NTType` command is not part of PowerShell by default and must be provided by an external module.

After retrieving the mappings, the script converts these hexadecimal access masks into standard and generic rights.
It outputs objects that detail which standard and generic rights are represented by each mapping, allowing easy filtering
and additional pipeline processing.

.PARAMETER OutputFile
When specified, the decoded results are written to the provided file path in CSV format. Otherwise, results are written 
to the pipeline as objects.

.NOTES
Dependencies:
- Requires a module that provides `Get-NTType`. This module is not included with Windows or PowerShell by default. 
  You will need to install or import the module that provides this command before running this script.

Example modules that might provide `Get-NTType` could be third-party security or Windows internals modules. Check with the provider of
`Get-NTType` or your system documentation for how to install it.

.EXAMPLE
PS C:\> .\Decode-NTTypeMappings.ps1
Retrieves NT Type mappings via Get-NTType and outputs them as objects.

.EXAMPLE
PS C:\> .\Decode-NTTypeMappings.ps1 -OutputFile C:\temp\NTTypeMappings.csv
Retrieves NT Type mappings and writes them to a CSV file for later analysis.

.LINK
Further reading on NT Security and Access Masks: 
https://docs.microsoft.com/windows/win32/secauthz/access-masks
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$OutputFile
)

begin {
    # Known standard and generic rights constants (partial list).
    $standardRights = @{
        DELETE        = 0x00010000
        READ_CONTROL  = 0x00020000
        WRITE_DAC     = 0x00040000
        WRITE_OWNER   = 0x00080000
        SYNCHRONIZE   = 0x00100000
    }

    # Generic Rights (common mappings in Windows)
    $genericRights = @{
        GENERIC_READ    = 0x80000000
        GENERIC_WRITE   = 0x40000000
        GENERIC_EXECUTE = 0x20000000
        GENERIC_ALL     = 0x10000000
    }

    # Check if Get-NTType command is available
    if (-not (Get-Command Get-NTType -ErrorAction SilentlyContinue)) {
        Write-Error "The command 'Get-NTType' is not available. Please install or import the necessary module before running this script."
        return
    }
}

process {
    # Retrieve the type information
    $typeInfo = Get-NTType | Select-Object Name, GenericMapping

    $results = foreach ($type in $typeInfo) {
        # Parse the generic mapping string
        $mappingParts = $type.GenericMapping -split ' '
        $mapHash = @{}

        foreach ($part in $mappingParts) {
            $subParts = $part -split ':'
            $key = $subParts[0]  # R, W, E, A
            $hexVal = $subParts[1]
            $mapHash[$key] = [Convert]::ToInt32($hexVal, 16)
        }

        # For each mapping (R, W, E, A), decode known bits and output as objects
        foreach ($genericKey in $mapHash.Keys) {
            $value = $mapHash[$genericKey]

            # Determine which standard rights are set
            $stdRightsFound = $standardRights.GetEnumerator() | Where-Object {
                ($value -band $_.Value) -eq $_.Value
            } | ForEach-Object { $_.Key }

            # Determine which generic rights are set
            $genRightsFound = $genericRights.GetEnumerator() | Where-Object {
                ($value -band $_.Value) -eq $_.Value
            } | ForEach-Object { $_.Key }

            [PSCustomObject]@{
                TypeName       = $type.Name
                MappingKey     = $genericKey
                HexValue       = ('0x' + $value.ToString('X8'))
                StandardRights = if ($stdRightsFound) { $stdRightsFound } else { @() }
                GenericRights  = if ($genRightsFound) { $genRightsFound } else { @() }
            }
        }
    }

    if ($OutputFile) {
        $results | Export-Csv -Path $OutputFile -NoTypeInformation
    } else {
        $results
    }
}
