<#
.SYNOPSIS
    This script will decrypt a file using PSPGP as long as you've already provided a private key.
.DESCRIPTION
    Enter the path to the file you want to use into the private key variable and run the command with the appropriate parameters.

.EXAMPLE
 .\pgpDecrypt.ps1 -File2Decrypt_Input "C:\path\to\yourfile.txt.pgp" -File2Decrypt_Output "C:\path\to\yourfile.txt" -Password (Read-Host -AsSecureString "Enter password")
#>

# Checks to make sure the pspgp module is installed
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$File2Decrypt_Input,

    [Parameter(Mandatory = $true)]
    [string]$File2Decrypt_Output,

    [Parameter(Mandatory = $true)]
    [SecureString]$Password
)

function Decrypt-PgpItem {
    param (
        [string]$File2Decrypt_Input,
        [string]$File2Decrypt_Output,
        [SecureString]$Password
    )

    $pspgpInstalled = Get-Module | Where-Object -Property 'Name' -Contains 'pspgp'
    
    if ($null -eq $pspgpInstalled) {
        try {
            Import-Module PSPGP
            Write-Host "PSPGP Module was installed"
        }
        catch {
            Write-Host "Failed to install PSPGP Module. Please check your internet connection or repository settings."
        }
    }
    else {
        Import-Module PSPGP
        Write-Host "PSPGP Module was already installed"
    }

    # Path to your private key
    $privateKey = "C:\Path\to\private.key"

    # Convert SecureString to plain text for use in the command
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $PlainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)

    # Decrypts the file
    Unprotect-PGP -FilePathPrivate $privateKey -FilePath $File2Decrypt_Input -OutFilePath $File2Decrypt_Output -Password $PlainTextPassword

    Write-Host "Your file has been decrypted"

    # Free the BSTR memory
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
}

# Call the function with the provided parameters
Decrypt-PgpItem -File2Decrypt_Input $File2Decrypt_Input -File2Decrypt_Output $File2Decrypt_Output -Password $Password
