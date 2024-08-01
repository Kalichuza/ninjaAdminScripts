
# PGP Encryption and Decryption Scripts

This repository contains 4 PowerShell scripts for encrypting and decrypting files using PGP (Pretty Good Privacy) with the `pspgp` module. The encryp/decrypt syntax is similar for a file and a folder. Look below to see the proper commands. 

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

## Encrypt a File or Folser

1. Open PowerShell.
2. Navigate to the directory containing `pgpEncrypt.ps1`.
3. Open the script in your editor of your choice and replace the ```$publicKey``` variable with the path to your publickey.asc file.
4. Run the script with the appropriate parameters:

For a File:
   ```powershell
   .\pgpEncrypt.ps1 -File2Encrypt_Input "C:\path\to\yourfile.txt" -File2Encrypt_Output "C:\path	o\yourfile.txt.pgp"
   ```
For a Folder:
```powershell
   .\pgpEncryptdir.ps1 -InputDirectory "C:\path\to\directory" -OutputDirectory "C:\path\to\output\directory"
```
## Decrypt a File or Folder

1. Open PowerShell.
2. Navigate to the directory containing `pgpDecrypt.ps1`.
3. Open the script in your editor of your choice and replace the ```$privateKey``` variable with the path to your pprivatekey.asc file.
4. Run the script with the appropriate parameters.
5. You will be prompted to enter the password to decrypt:

For a file:
   ```powershell
   .\pgpDecrypt.ps1 -File2Decrypt_Input "C:\path\to\yourfile.txt.pgp" -File2Decrypt_Output "C:\path\to\yourfile.txt"
   ```
For a Folder:
   ```powershell
   .\pgpDecryptDir.ps1 -InputDirectory "C:\path\to\directory" -OutputDirectory "C:\path\to\output\directory" -Password (Read-Host -AsSecureString "Enter password")
   ```
