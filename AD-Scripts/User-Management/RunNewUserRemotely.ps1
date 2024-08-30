<#
.SYNOPSIS
    Wrapper script to run the NewAdUser.ps1 script stored on a server with dynamic parameters.

.DESCRIPTION
    This script is designed to be used in the NinjaOne scripting engine. It fetches and executes the New-Employee.ps1 script from a static location on a server. The script takes dynamic parameters, which can be set at runtime in NinjaOne.

.PARAMETER FirstName
    The first name of the new employee. This parameter is passed to the New-Employee.ps1 script.

.PARAMETER LastName
    The last name of the new employee. This parameter is passed to the New-Employee.ps1 script.

.PARAMETER Title
    The job title of the new employee. This parameter is passed to the New-Employee.ps1 script.

.PARAMETER EmailDomain
    The email domain to be used for generating the user's email address. This parameter is passed to the New-Employee.ps1 script.

.EXAMPLE
    .\Run-NewEmployeeScript.ps1 -FirstName "John" -LastName "Doe" -Title "Systems Engineer" -EmailDomain "company.com"

.NOTES
    Author: Your Name
    Date: 2024-08-29
    Version: 1.0
#>

param (
    [Parameter(Mandatory)]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [string]$LastName,

    [Parameter()]
    [string]$Title,

    [Parameter()]
    [string]$EmailDomain = "example.com"
)

# Path to the main script on the server
$scriptPath = "\\server-name\share\New-Employee.ps1"

# Construct the command to execute the main script with parameters
$command = "& $scriptPath -FirstName $FirstName -LastName $LastName -Title $Title -EmailDomain $EmailDomain"

# Execute the command
Invoke-Expression $command
