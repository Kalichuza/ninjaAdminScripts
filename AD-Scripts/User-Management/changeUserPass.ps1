<#
.SYNOPSIS
    This script sets a new password for an Active Directory user and forces them to change the password at the next logon.

.DESCRIPTION
    The script takes a username in the format of domain\username and a password as parameters. It converts the plain text password to a secure string and sets it as the new password for the specified user. Additionally, it forces the user to change their password at the next logon.

.PARAMETER user
    The username of the Active Directory account in the format of domain\username.

.PARAMETER password
    The new password to set for the user.

.EXAMPLE
    .\YourScriptName.ps1 -user "domain\jdoe" -password "newpassword"
    This command sets the password for the user 'jdoe' in the 'domain' domain to 'newpassword' and forces the user to change the password at the next logon.

.EXAMPLE
    .\YourScriptName.ps1 -user "company\asmith" -password "securepassword123"
    This command sets the password for the user 'asmith' in the 'company' domain to 'securepassword123' and forces the user to change the password at the next logon.

.EXAMPLE
    .\YourScriptName.ps1 -user "example\mjones" -password "Pa$$w0rd!"
    This command sets the password for the user 'mjones' in the 'example' domain to 'Pa$$w0rd!' and forces the user to change the password at the next logon.

#>

param(
    [string]$user,
    [string]$password
)

# Convert the plain text password to a secure string
$NewPwd = ConvertTo-SecureString $password -AsPlainText -Force

# Set the new password for the user
Set-ADAccountPassword -Identity $user -NewPassword $NewPwd -Reset

# Force the user to change their password at the next logon
Set-ADUser -Identity $user -ChangePasswordAtLogon $true
