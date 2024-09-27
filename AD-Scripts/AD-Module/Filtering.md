Certainly! Here's a cheat sheet for filtering Active Directory (AD) objects using PowerShell. This is especially useful when you're using the `ActiveDirectory` module in PowerShell to query and manage AD.

### Common Filters in Active Directory PowerShell Module

#### 1. **Get AD User by Username**
```powershell
Get-ADUser -Filter { SamAccountName -eq "username" }
```

#### 2. **Get AD Users in a Specific Organizational Unit (OU)**
```powershell
Get-ADUser -Filter * -SearchBase "OU=Sales,DC=domain,DC=com"
```

#### 3. **Get Disabled AD Users**
```powershell
Get-ADUser -Filter { Enabled -eq $false }
```

#### 4. **Get AD Users with a Specific Email Domain**
```powershell
Get-ADUser -Filter { EmailAddress -like "*@example.com" }
```

#### 5. **Get AD Groups by Name**
```powershell
Get-ADGroup -Filter { Name -like "*Admins*" }
```

#### 6. **Get AD Computer by Name**
```powershell
Get-ADComputer -Filter { Name -eq "COMPUTERNAME" }
```

#### 7. **Get AD Users with a Specific Job Title**
```powershell
Get-ADUser -Filter { Title -eq "Manager" }
```

#### 8. **Get AD Users Last Logged In Before a Certain Date**
```powershell
Get-ADUser -Filter { LastLogonDate -lt "01/01/2023" }
```

#### 9. **Get AD Users with Password Never Expires**
```powershell
Get-ADUser -Filter { PasswordNeverExpires -eq $true }
```

#### 10. **Get AD Users with a Specific Department**
```powershell
Get-ADUser -Filter { Department -eq "IT" }
```

#### 11. **Get AD Groups with Specific Members**
```powershell
Get-ADGroup -Filter { Members -like "*username*" }
```

#### 12. **Get AD Users who are Account Expiring Soon**
```powershell
Get-ADUser -Filter { AccountExpirationDate -lt (Get-Date).AddDays(30) }
```

### Advanced Filters

#### 13. **Get AD Users who have not Logged in Recently**
```powershell
Get-ADUser -Filter { LastLogonDate -lt (Get-Date).AddDays(-90) }
```

#### 14. **Get AD Users Based on Proxy Addresses**
```powershell
Get-ADUser -Filter { ProxyAddresses -like "*smtp:username@example.com*" }
```

#### 15. **Get AD Users by Custom Attribute**
```powershell
Get-ADUser -Filter { extensionAttribute1 -eq "Value" }
```

### Combining Filters

#### 16. **Get AD Users who are in IT Department and Active**
```powershell
Get-ADUser -Filter { Department -eq "IT" -and Enabled -eq $true }
```

#### 17. **Get AD Computers with Specific OS and OU**
```powershell
Get-ADComputer -Filter { OperatingSystem -like "*Windows 10*" -and Enabled -eq $true } -SearchBase "OU=Computers,DC=domain,DC=com"
```

### Filter Operators

- **`-eq`**: Equals
- **`-ne`**: Not Equals
- **`-lt`**: Less Than
- **`-gt`**: Greater Than
- **`-le`**: Less Than or Equal
- **`-ge`**: Greater Than or Equal
- **`-like`**: Wildcard Comparison (e.g., `-like "*admin*"`)
- **`-notlike`**: Negation of Wildcard Comparison
- **`-and`**: Combines multiple conditions (logical AND)
- **`-or`**: Combines multiple conditions (logical OR)

### Tips
- Always test your filters with `-WhatIf` before running the command in a production environment.
- You can use `Select-Object` to limit the output to specific properties.
- Use `-SearchBase` to limit the search to a specific OU or container.

This cheat sheet should help you filter AD objects effectively using the `ActiveDirectory` module in PowerShell!