<#
.SYNOPSIS
    Recursively searches a directory for files matching a specific pattern.

.DESCRIPTION
    This script searches through all the files and directories under a specified path
    and filters the results based on the provided search pattern.

.PARAMETER DirectoryPath
    The path to the directory where the search should begin.

.PARAMETER SearchPattern
    The pattern to filter the files (e.g., *.txt, *.log). Supports wildcards.

.EXAMPLE
    Search-DirectoryRecursively -DirectoryPath "C:\Path\To\Directory" -SearchPattern "*.txt"
    This command will search the specified directory and all its subdirectories for files with a .txt extension.

.NOTES
    Author: [Your Name]
    Date: [Date]
    Version: 1.0

    This script uses the Get-ChildItem cmdlet to perform the recursive search.

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$DirectoryPath,

    [Parameter(Mandatory = $true)]
    [string]$SearchPattern
)

function Search-DirectoryRecursively {
    param (
        [string]$DirectoryPath,
        [string]$SearchPattern
    )

    $files = Get-ChildItem -Path $DirectoryPath -Recurse -Filter $SearchPattern

    foreach ($file in $files) {
        Write-Output "Found file: $($file.FullName)"
    }
}

# Call the function
Search-DirectoryRecursively -DirectoryPath $DirectoryPath -SearchPattern $SearchPattern
