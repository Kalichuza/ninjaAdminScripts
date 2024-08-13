**A List of Useful PowerShell Modules**


**Secrets*
- Secrets Management | https://github.com/powershell/secretmanagement
```powershell
Install-Module -Name Microsoft.PowerShell.SecretManagement
```

- Secrets Vault | 
```powershell
Install-Module -Name Microsoft.PowerShell.SecretStore
```

- A  module to en/decode Base64
```powershell
Install-Module -Name jakoby-b64
Install-Module -Name emoji.64
```
- A DNS Security Testing Module 
```powershell
Install-Module -Name dns
```

- CleanUpMonster 
|    https://github.com/EvotecIT/CleanupMonster
```powershell
Install-Module -Name CleanupMonster -Force -Verbose
```

- Microsoft.WinGet.Client
```powershell
Install-Module -Name Microsoft.WinGet.Client
```

- 7Zip4Powershell
```powershell
Install-Module -Name 7Zip4Powershell
```

- A module for interacting with User
```powershell
Install-Module -Name SecurityPolicy
```

- Capture and parse CDP and LLDP packets on local or remote computers
```powershell
Install-Module -Name PSDiscoveryProtocol
```

- PGP encryption module | https://github.com/EvotecIT/PSPGP/blob/master/README.MD
```powershell
Install-Module -Name PSPGP
```

- PSWriteColor 1.0.1
Write-Color is a wrapper around Write-Host allowing you to create nice looking scripts, with colorized output. It provides easy manipulation of colors, logging output to file (log) and nice formatting options out of the box.
```powershell
Install-Module -Name PSWriteColor
```
   
- PSEventViewer 2.0.0
Simple module allowing parsing of event logs. Has its own quirks...
```powershell
Install-Module -Name PSEventViewer
```

- Transferetto 1.0.0
Module which allows ftp, ftps, sftp file transfers with advanced features. It also allows to transfer files and directorires between servers using fxp protocol. As a side feature it allows to conenct to SSH and executes commands on it.
```powershell
Install-Module -Name Transferetto
```

- Pode 2.10.1 | https://github.com/Badgerati/Pode
A Cross-Platform PowerShell framework for creating web servers to host REST APIs and Websites. Pode also has support for being used in Azure Functions and AWS Lambda.
```powershell
Install-Module -Name Pode
```

- PSWritePDF 0.0.20
Little project to create, read, modify, split, merge PDF files on Windows, Linux and Mac.
```powershell
Install-Module -Name PSWritePDF
```


- Microsoft.PowerShell.ConsoleGuiTools 
```powershell
Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools
```

- Convert 1.5.0
Convert simplifies object conversions by exposing common requirements as PowerShell functions.
```powershell
Install-Module -Name Convert
```

- NinjaRmmApi 1.0.2
An unofficial PowerShell module to interact with NinjaRMM.
```powershell
Install-Module -Name NinjaRmmApi
```

**Active Directory**

- PSSharedGoods 
This module contains various cmdlets that simplify Active Directory management tasks, such as user and group management. It's a community-driven module with practical functions to help with everyday AD tasks.
```powershell
Install-Module PSSharedGoods -Scope CurrentUser
```

- AdminToolbox.ActiveDirectory | https://github.com/TheTaylorLee/AdminToolbox/
Functions for Active Directory
```powershell
Install-Module -Name AdminToolbox.ActiveDirectory
```

- ModernActiveDirectory | https://github.com/dakhama-mehdi/Modern_ActiveDirectory
New experience (Safe, Easy, Fast) given an overview of Active Directory environment from a beautiful interactive HTML report
```powershell
Install-Module -Name ModernActiveDirectory
```

- GPOZaurr | https://evotec.xyz/the-only-command-you-will-ever-need-to-understand-and-fix-your-group-policies-gpo/ | https://github.com/EvotecIT/GPOZaurr
```powershell
Install-Module -Name GPOZaurr -AllowClobber -Force
```

- Testimo - PowerShell Module | https://github.com/EvotecIT/Testimo
Testimo is a PowerShell Module to help with basic/more advanced testing of Active Directory and maybe in future other types of servers.
```powershell
Install-Module -Name Testimo -AllowClobber -Force
```

- ADEssentials | https://github.com/EvotecIT/ADEssentials
ADEssentials PowerShell module contains a set of commands that are useful for day to day activities when working with Active Directory
```powershell
Install-Module -Name ADEssentials -AllowClobber -Force
```

