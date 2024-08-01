
# PGP Encryption and Decryption Scripts

This repository contains two PowerShell scripts for encrypting and decrypting files using PGP (Pretty Good Privacy) with the `pspgp` module.

## Description

- **pgpEncrypt.ps1**: Encrypts a specified file using a provided public key.
- **pgpDecrypt.ps1**: Decrypts a specified file using a provided private key.

## Prerequisites

- PowerShell (version 5.1 or later)
- `pspgp` module

## Installation

### Install the `pspgp` Module

1. Open PowerShell as an administrator.
2. Run the following command to install the `pspgp` module from the PowerShell Gallery:

   ```powershell
   Install-Module -Name PSPGP -Force -Scope CurrentUser
   ```

3. Import the `pspgp` module:

   ```powershell
   Import-Module PSPGP
   ```

## Generate PGP Key Pair

To use the encryption and decryption scripts, you need a PGP key pair. Run the following command to generate a new PGP key pair:

```powershell
New-PGPKey -FilePathPublic "publickey.asc" -FilePathPrivate "privatekey.asc" -UserName "John Doe" -Password "your_password" -HashAlgorithm Sha256 -CompressionAlgorithm Zip -FileType Binary -PublicKeyAlgorithm RsaGeneral -SymmetricKeyAlgorithm Aes256
```

Replace `"John Doe"` and `"your_password"` with your desired username and password.

## Encrypt a File

1. Open PowerShell.
2. Navigate to the directory containing `pgpEncrypt.ps1`.
3. Run the script with the appropriate parameters:

   ```powershell
   .\pgpEncrypt.ps1 -File2Encrypt_Input "C:\path	o\yourfile.txt" -File2Encrypt_Output "C:\path	o\yourfile.txt.pgp"
   ```

### Script: `pgpEncrypt.ps1`

```powershell
<#
.SYNOPSIS
    This script will encrypt a file using PSPGP as long as you've already provided a public key.
.DESCRIPTION
    Enter the path to the file you want to use into the public key variable and run the command with the appropriate parameters.

.EXAMPLE
 .\pgpEncrypt.ps1 -File2Encrypt_Input "C:\path	o\yourfile.txt" -File2Encrypt_Output "C:\path	o\yourfile.txt.pgp"
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
```

## Decrypt a File

1. Open PowerShell.
2. Navigate to the directory containing `pgpDecrypt.ps1`.
3. Run the script with the appropriate parameters:

   ```powershell
   .\pgpDecrypt.ps1 -File2Decrypt_Input "C:\path	o\yourfile.txt.pgp" -File2Decrypt_Output "C:\path	o\yourfile.txt"
   ```

### Script: `pgpDecrypt.ps1`

```powershell
<#
.SYNOPSIS
    This script will decrypt a file using PSPGP as long as you've already provided a private key.
.DESCRIPTION
    Enter the path to the file you want to use into the private key variable and run the command with the appropriate parameters.

.EXAMPLE
 .\pgpDecrypt.ps1 -File2Decrypt_Input "C:\path	o\yourfile.txt.pgp" -File2Decrypt_Output "C:\path	o\yourfile.txt"
#>

# Checks to make sure the pspgp module is installed
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$File2Decrypt_Input,

    [Parameter(Mandatory)]
    [string]$File2Decrypt_Output
)

function Decrypt-PgpItem {
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
    $password = "your_password"  # If your private key requires a password

    # Decrypts the file
    Unprotect-PGP -FilePathPrivate $privateKey -FilePath $File2Decrypt_Input -OutFilePath $File2Decrypt_Output -Password $password

    Write-Host "Your file has been decrypted"
}

# Call the function with the provided parameters
Decrypt-PgpItem -File2Decrypt_Input $File2Decrypt_Input -File2Decrypt_Output $File2Decrypt_Output
```
