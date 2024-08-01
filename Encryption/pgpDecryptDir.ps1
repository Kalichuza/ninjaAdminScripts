<#
.SYNOPSIS
    This script will decrypt all PGP encrypted files in a specified directory using PSPGP as long as you've already provided a private key.
.DESCRIPTION
    Enter the path to the directory you want to use and run the command with the appropriate parameters.

.EXAMPLE
 .\pgpDecryptDir.ps1 -InputDirectory "C:\path\to\directory" -OutputDirectory "C:\path\to\output\directory" -Password (Read-Host -AsSecureString "Enter password")
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputDirectory,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory,

    [Parameter(Mandatory = $true)]
    [SecureString]$Password
)

function Decrypt-PgpDirectory {
    param (
        [string]$InputDirectory,
        [string]$OutputDirectory,
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

    # Check if the output directory exists, if not, create it
    if (-not (Test-Path -Path $OutputDirectory)) {
        New-Item -ItemType Directory -Path $OutputDirectory
    }

    # Path to your private key
    $privateKey = "C:\Path\to\private.key"

    # Convert SecureString to plain text for use in the command
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $PlainTextPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)

    # Get all PGP files in the directory
    $files = Get-ChildItem -Path $InputDirectory -Filter "*.pgp" -File

    foreach ($file in $files) {
        $outputFile = Join-Path -Path $OutputDirectory -ChildPath ($file.Name -replace "\.pgp$", "")
        try {
            Unprotect-PGP -FilePathPrivate $privateKey -FilePath $file.FullName -OutFilePath $outputFile -Password $PlainTextPassword
            Write-Host "Decrypted: $($file.FullName) to $outputFile"
        }
        catch {
            Write-Warning "Failed to decrypt file $($file.FullName): $_"
        }
    }

    # Free the BSTR memory
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
}

# Call the function with the provided parameters
Decrypt-PgpDirectory -InputDirectory $InputDirectory -OutputDirectory $OutputDirectory -Password $Password
