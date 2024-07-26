# Windows User Folder Cleanup and Profile Transfer Script

This repository contains several PowerShell scripts:
1. Several scripts to transfer a user's profile directory to another location. 
2. A to delete a user's folder from the system.


## Prerequisites

- Ensure PowerShell is installed on your target machine.
- Make sure you have the necessary permissions to delete user folders and create network drives.

## 1. Profile Transfer Script

### Usage Instructions

1. Upload the script to the target machine.

2. Set up a mapped drive to your target folder:
    ```powershell
    net use J: \\SERVER\Path\To\NetDrive /user:domain\administrator P4ssWord
    ```

4. Initiate the transfer from an admin account:
    ```powershell
    .\moveUserAll.ps1 -source "C:\Path\To\Origin" -destination "J:" -username "domain\administrator" -password 'PassWord'
    ```
5. On the target machine, create a new local user; sign in and out with that profile.
6. Then, map the J: drive and reverse the transfer to the new profile:
    ```powershell
    net use J: \\SERVER\Path\To\NetDrive /user:domain\administrator P4ssWord
    .\moveUserAll.ps1 -source "J:" -destination "C:\Users\NewProfile" -username "domain\administrator" -password 'PassWord'
    ```
7. Use a tool such as ProfWiz to point windows to the location of the new user profile directory.

## 2. User Folder Cleanup Script

### Usage Instructions

1. Run the script to delete the user folder:
    ```powershell
    .\RemoveUserFolder.ps1 -folderName "username"
    ```

