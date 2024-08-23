<#
.SYNOPSIS
    Searches input content for lines matching a specified regex pattern.

.DESCRIPTION
    This script takes content from the pipeline or as direct input and searches for lines that match
    a given regex pattern. The regex pattern is provided as a parameter at runtime.

.PARAMETER RegexPattern
    The regular expression pattern to search for within the content.

.INPUTS
    System.String
    You can pipe string input to this script from commands such as Get-Content or Import-Csv.

.OUTPUTS
    System.String
    The script outputs lines from the input content that match the regex pattern.

.EXAMPLE
    Get-Content "C:\Path\To\File.txt" | Search-ContentWithRegex -RegexPattern "\blogo\b"
    This command will search through the content of the specified file for lines containing the word "logo".

.EXAMPLE
    Import-Csv "C:\Path\To\File.csv" | Select-Object -ExpandProperty SomeColumn | Search-ContentWithRegex -RegexPattern "\bexample\b"
    This command will search through the CSV content for lines containing the word "example".

.NOTES
    Author: [Your Name]
    Date: [Date]
    Version: 1.2

.LINK
    https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-foreach
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$RegexPattern,

    [Parameter(ValueFromPipeline = $true)]
    [string]$InputObject
)

process {
    if ($InputObject -match $RegexPattern) {
        Write-Output $InputObject
    }
}
