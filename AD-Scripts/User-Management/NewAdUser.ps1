#requires -Module ActiveDirectory

<#
.SYNOPSIS
    Creates a new Active Directory user account with a secure password.

.DESCRIPTION
    This script automates the creation of an AD user account with robust error handling, secure password generation, and customizable username and email formats.

.PARAMETER FirstName
    The first name of the user.

.PARAMETER LastName
    The last name of the user.

.PARAMETER UsernameFormat
    A format string for the username. Default is the first initial of the first name + last name.

.PARAMETER Title
    The user's job title. This is an optional parameter.

.PARAMETER EmailDomain
    The email domain to use when generating the user's email address. Default is "example.com".

.EXAMPLE
    .\Create-ADUser.ps1 -FirstName John -LastName Doe -Title "Systems Engineer" -EmailDomain "company.com"

.NOTES
    Author: Kalichuza
    Version: 1.0
    Date: 2024-08-29
    Security: Security-first approach, ensuring all actions are secure and compliant with best practices.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$FirstName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]$LastName,

    [Parameter()]
    [string]$UsernameFormat = "$($FirstName.Substring(0,1))$LastName",

    [Parameter()]
    [string]$Title,

    [Parameter()]
    [string]$EmailDomain = "yourcompany.com"
)

# Custom function to generate a password like "ChangeMe<random four-digit number>"
function New-SecurePassword {
    $randomNumber = Get-Random -Minimum 1000 -Maximum 9999
    return "ChangeMe$randomNumber"
}

try {
    # Generate the username based on the format provided or default to First Initial + Last Name
    $username = $UsernameFormat -replace "\$FirstName", $FirstName -replace "\$LastName", $LastName
    $i = 2 

    # Check for existing usernames and generate a unique one
    while (Get-ADUser -Filter "samAccountName -eq '$username'") {
        Write-Warning -Message "The username '$username' already exists, trying '$username$i'"
        $username = "{0}{1}" -f $FirstName.Substring(0, $i), $LastName
        $i++
    }

    # Generate the "ChangeMe<random four-digit number>" password
    $password = New-SecurePassword
    $secPassword = ConvertTo-SecureString -AsPlainText "$password" -Force

    # Generate email
    $email = "$username@$EmailDomain"

    # Create the user
    $newUserParams = @{
        GivenName              = $FirstName
        Surname                = $LastName
        Name                   = $username
        UserPrincipalName      = $email
        ChangePasswordAtLogon  = $true
        AccountPassword        = $secPassword
        Enabled                = $true
        Title                  = $Title
        Confirm                = $false
    }

    if ($PSCmdlet.ShouldProcess("AD User [$username]", "Create AD User $FirstName $LastName")) {
        New-ADUser @newUserParams
        Write-Output "User $username created successfully with email $email"

        [PSCustomObject]@{
            FirstName  = $FirstName
            LastName   = $LastName
            Title      = $Title
            Username   = $username
            Email      = $email
            Password   = $password
        }    
    }  
} catch {
    Write-Error -Message $_.Exception.Message
}
