<#
.SYNOPSIS
    This script will encrypt all files in a specified directory using PSPGP as long as you've already provided a public key.
.DESCRIPTION
    Enter the path to the directory you want to use and run the command with the appropriate parameters.

.EXAMPLE
 .\pgpEncryptDir.ps1 -InputDirectory "C:\path\to\directory" -OutputDirectory "C:\path\to\output\directory"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputDirectory,

    [Parameter(Mandatory = $true)]
    [string]$OutputDirectory
)

function Encrypt-PgpDirectory {
    param (
        [string]$InputDirectory,
        [string]$OutputDirectory
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

    # Path to your public key
    $publicKey = "C:\Path\to\public.key"

    # Get all files in the directory
    $files = Get-ChildItem -Path $InputDirectory -File

    foreach ($file in $files) {
        $outputFile = Join-Path -Path $OutputDirectory -ChildPath ($file.Name + ".pgp")
        try {
            Protect-PGP -FilePathPublic $publicKey -FilePath $file.FullName -OutFilePath $outputFile
            Write-Host "Encrypted: $($file.FullName) to $outputFile"
        }
        catch {
            Write-Warning "Failed to encrypt file $($file.FullName): $_"
        }
    }
}

# Call the function with the provided parameters
Encrypt-PgpDirectory -InputDirectory $InputDirectory -OutputDirectory $OutputDirectory
