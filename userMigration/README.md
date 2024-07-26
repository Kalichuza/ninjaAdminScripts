# User Folder Cleanup and Profile Transfer Script

This repository contains two PowerShell scripts:
1. A script to delete a user's folder from the system.
2. A script to transfer the folder to a network drive.

## Prerequisites

- Ensure PowerShell is installed on your target machine.
- Make sure you have the necessary permissions to delete user folders and create network drives.

## 1. User Folder Cleanup Script

### Usage Instructions

1. Run the script to delete the user folder:
    ```powershell
    .\RemoveUserFolder.ps1 -folderName "username"
    ```

## 2. Profile Transfer Script

### Usage Instructions

1. Upload the script to the target machine.

2. Set up a mapped drive to your target folder:
    ```powershell
    net use J: \\SERVER\Path\To\NetDrive /user:domain\administrator P4ssWord
    ```

3. Initiate the transfer:
    ```powershell
    .\moveFolder2NetDrive.ps1 -source "C:\Path\To\Origin" -destination "J:" -username "domain\administrator" -password 'PassWord'
    ```

4. On the target machine, map the J: drive and reverse the transfer to the new profile:
    ```powershell
    net use J: \\SERVER\Path\To\NetDrive /user:domain\administrator P4ssWord
    .\moveFolder2NetDrive.ps1 -source "J:" -destination "C:\Users\NewProfile" -username "domain\administrator" -password 'PassWord'
    ```
