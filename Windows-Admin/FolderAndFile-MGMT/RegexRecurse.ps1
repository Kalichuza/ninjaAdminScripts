<#
.SYNOPSIS
    Recursively searches files in a directory for content matching a specified regex pattern.

.DESCRIPTION
    This script searches through all files within a specified directory and its subdirectories
    for occurrences of content that matches a given regex pattern. The regex pattern is provided
    as a parameter at runtime.

.PARAMETER DirectoryPath
    The path to the directory where the search should begin.

.PARAMETER RegexPattern
    The regular expression pattern to search for within the files.

.EXAMPLE
    Search-FileSystemWithRegex -DirectoryPath "C:\Path\To\Directory" -RegexPattern "\blogo\b"
    This command will search the specified directory and all its subdirectories for files containing the word "logo".

.NOTES
    Author: [Your Name]
    Date: [Date]
    Version: 1.0

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-childitem
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$DirectoryPath,

    [Parameter(Mandatory = $true)]
    [string]$RegexPattern
)

function Search-FileSystemWithRegex {
    param (
        [string]$DirectoryPath,
        [string]$RegexPattern
    )

    $files = Get-ChildItem -Path $DirectoryPath -Recurse -File

    foreach ($file in $files) {
        try {
            $content = Get-Content -Path $file.FullName -ErrorAction Stop
            if ($content -match $RegexPattern) {
                Write-Output "Match found in file: $($file.FullName)"
            }
        } catch {
            Write-Output "Could not read file: $($file.FullName). Error: $_"
        }
    }
}

# Call the function
Search-FileSystemWithRegex -DirectoryPath $DirectoryPath -RegexPattern $RegexPattern
