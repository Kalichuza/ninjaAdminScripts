
<#
.SYNOPSIS
    This script will encrypt a file using PSPGP as long as yuove already provided a public key
.DESCRIPTION
    Enter in the path to the file you want to use into the  public key variable and run the command with the appropriate parameters 

.EXAMPLE
 .\pgpEncrypt.ps1 -File2Encrypt_Input "C:\path\to\yourfile.txt" -File2Encrypt_Output "C:\path\to\yourfile.txt.pgp"
   
#>

# Checks to make sure the pspgp module is installed
function Install-ModulePSPGP {
    $pspgpInstalled = Get-Module | Where-Object -Property 'Name' -Contains 'pspgp'

    if ($null -eq $pspgpInstalled) {
        try {
            Install-Module -Name PSPGP -Force -Scope CurrentUser
            Import-Module PSPGP
            Write-Host "PSPGP Module was installed"
        } catch {
            Write-Host "Failed to install PSPGP Module. Please check your internet connection or repository settings."
        }
    } else {
        Import-Module PSPGP
        Write-Host "PSPGP Module was already installed"
    }
}


function Encrypt-PGP {
    param(
    [string]$File2Encrypt_Input,
    [string]$File2Encrypt_Output
)


$publicKey = "<Path\to\public.key>"

# Encrypts the file
Protect-PGP -InputFile $File2Encrypt_Input -OutputFile $File2Encrypt_Output -PublicKeyFile $publicKey
Write-Host "Your file has been encrypted"
}



