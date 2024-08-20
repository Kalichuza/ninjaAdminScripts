# PSWindowsUpdate Module Guide

## Overview

The `PSWindowsUpdate` module is a set of PowerShell cmdlets that allow you to manage Windows updates on your local or remote machines. It provides an interface to search, download, install, and remove Windows updates, as well as configure update settings.

## Prerequisites

- Windows PowerShell 5.1 or PowerShell 7.x
- Administrative privileges to install the module and manage updates

## Installation

To install the `PSWindowsUpdate` module, run the following command:

```powershell
Install-Module -Name PSWindowsUpdate -Force -SkipPublisherCheck
```

If you're prompted to install the NuGet provider, press `Y` to confirm.

### Importing the Module

After installing the module, you need to import it into your session:

```powershell
Import-Module -Name PSWindowsUpdate
```

## Basic Usage

### 1. Check for Available Updates

To check for available updates on your system:

```powershell
Get-WindowsUpdate
```

This command lists all available updates. You can filter updates by specifying the `-KBArticleID` parameter:

```powershell
Get-WindowsUpdate -KBArticleID KB5007651
```

### 2. Install Updates

To install all available updates:

```powershell
Install-WindowsUpdate -AcceptAll -AutoReboot
```

- `-AcceptAll`: Automatically accepts all update prompts.
- `-AutoReboot`: Reboots the system automatically if required by the updates.

To install a specific update by its KB number:

```powershell
Install-WindowsUpdate -KBArticleID KB5007651 -AcceptAll -AutoReboot
```

### 3. Hide an Update

If you want to hide a specific update so that it doesn’t get installed:

```powershell
Hide-WindowsUpdate -KBArticleID KB5007651
```

### 4. Unhide a Hidden Update

To unhide an update that was previously hidden:

```powershell
Show-WindowsUpdate -KBArticleID KB5007651
```

### 5. Remove Installed Updates

To remove an update that has already been installed:

```powershell
Remove-WindowsUpdate -KBArticleID KB5007651 -Force
```

The `-Force` parameter forces the removal of the update without prompts.

### 6. Configure Windows Update Settings

You can configure automatic update settings with the following command:

```powershell
Set-WindowsUpdateSetting -AutoDownload -ScheduledInstallDay 0 -ScheduledInstallTime 3
```

This configures Windows to automatically download updates and install them every day at 3 AM.

### 7. Check Update History

To view the history of installed updates:

```powershell
Get-WUHistory
```

This command provides a list of updates that have been installed on the system.

## Remote Management

The `PSWindowsUpdate` module also supports managing updates on remote machines.

### 1. Install and Import the Module on a Remote Machine

To install the module on a remote machine:

```powershell
Invoke-Command -ComputerName RemotePCName -ScriptBlock {
    Install-Module -Name PSWindowsUpdate -Force -SkipPublisherCheck
    Import-Module -Name PSWindowsUpdate
}
```

### 2. Check for Updates on a Remote Machine

```powershell
Invoke-WUJob -ComputerName RemotePCName -Script { Get-WindowsUpdate }
```

### 3. Install Updates on a Remote Machine

```powershell
Invoke-WUJob -ComputerName RemotePCName -Script { Install-WindowsUpdate -AcceptAll -AutoReboot }
```

### 4. Configure Update Settings on a Remote Machine

```powershell
Invoke-WUJob -ComputerName RemotePCName -Script {
    Set-WindowsUpdateSetting -AutoDownload -ScheduledInstallDay 0 -ScheduledInstallTime 3
}
```

## Help and Documentation

For more detailed information about each cmdlet, use the `Get-Help` cmdlet:

```powershell
Get-Help Get-WindowsUpdate -Full
```

## Conclusion

The `PSWindowsUpdate` module is a powerful tool for managing Windows updates via PowerShell, offering both local and remote management capabilities. It streamlines the process of keeping systems up-to-date, making it an essential tool for IT administrators.


This `README.md` provides an overview of the module, installation instructions, and examples of how to use its various features. You can adjust it as needed for your specific use case or environment.
