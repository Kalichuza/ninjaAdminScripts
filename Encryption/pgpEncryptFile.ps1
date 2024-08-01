
<#
.SYNOPSIS
    This script will encrypt a file using PSPGP as long as yuove already provided a public key
.DESCRIPTION
    Enter in the path to the file you want to use into the  public key variable and run the command with the appropriate parameters 

.EXAMPLE
 .\pgpEncryptFile.ps1 -File2Encrypt_Input "C:\path\to\yourfile.txt" -File2Encrypt_Output "C:\path\to\yourfile.txt.pgp"
   
#>

# Checks to make sure the pspgp module is installed
[CmdletBinding()]
param(
        [Parameter(Mandatory)]
        [string]$File2Encrypt_Input,

        [Parameter(Mandatory)]
        [string]$File2Encrypt_Output
    ) 
function Encrypt-PgpItem {
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

    # Path to your public key
    $publicKey = "<Path\to\public.key>"

    # Encrypts the file
    
    Protect-PGP -FilePathPublic $publicKey -FilePath $File2Encrypt_Input -OutFilePath $File2Encrypt_Output

    Write-Host "Your file has been encrypted"
}



