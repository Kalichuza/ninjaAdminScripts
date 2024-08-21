Let's update the setup instructions for configuring your Server Core setup and creating an SMB share, including setting up permissions using PowerShell.

### **1. Domain Join the Server Core:**

1. **Rename the Server (Optional):**
   ```powershell
   Rename-Computer -NewName "NewServerName" -Restart
   ```

2. **Join the Domain:**
   ```powershell
   Add-Computer -DomainName "yourdomain.com" -Credential yourdomain\adminuser
   ```
   - Enter the password when prompted.

3. **Restart the Server:**
   ```powershell
   Restart-Computer
   ```

### **2. Configure Static IP Address:**

1. **Identify the Network Interface:**
   ```powershell
   Get-NetAdapter
   ```

2. **Set the Static IP Address:**
   ```powershell
   New-NetIPAddress -InterfaceIndex <InterfaceIndex> -IPAddress <StaticIP> -PrefixLength <SubnetPrefixLength> -DefaultGateway <DefaultGateway>
   ```

   Example:
   ```powershell
   New-NetIPAddress -InterfaceIndex 2 -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1
   ```

3. **Set DNS Servers:**
   ```powershell
   Set-DnsClientServerAddress -InterfaceIndex 2 -ServerAddresses 192.168.1.2,8.8.8.8
   ```

### **3. Install the File Server Role (if not already installed):**

```powershell
Install-WindowsFeature -Name FS-FileServer
```

### **4. Create and Configure the SMB Share:**

1. **Create a Directory for the SMB Share:**
   ```powershell
   New-Item -Path "C:\Shares\NetDump" -ItemType Directory
   ```

2. **Get the Current ACL for the Directory:**
   ```powershell
   $acl = Get-Acl "C:\Shares\NetDump"
   ```

3. **Create a File System Access Rule:**
   Replace `"Administrators"` with the correct user or group if necessary.
   ```powershell
   $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
   ```

4. **Apply the ACL to the Directory:**
   ```powershell
   $acl.SetAccessRule($rule)
   Set-Acl -Path 'C:\Shares\NetDump' -AclObject $acl
   ```

5. **Create the SMB Share:**
   ```powershell
   New-SmbShare -Name 'NET-DUMPSTER' -Path 'C:\Shares\NetDump' -FullAccess 'Administrators'
   ```

   - **`-Name 'NET-DUMPSTER'`**: This is the name of the share.
   - **`-Path 'C:\Shares\NetDump'`**: The path to the directory being shared.
   - **`-FullAccess 'Administrators'`**: Grants full access to the specified user or group. Replace `'Administrators'` with the correct domain or local group/user as needed.

### **5. (Optional) Verify the SMB Share and Permissions:**

1. **List All SMB Shares:**
   ```powershell
   Get-SmbShare
   ```

2. **Verify the ACL on the Directory:**
   ```powershell
   Get-Acl -Path 'C:\Shares\NetDump'
   ```

### **6. (Optional) Allow SMB Through the Firewall:**

Ensure the Windows Firewall allows SMB traffic:

```powershell
New-NetFirewallRule -DisplayName "SMB Share Rule" -Direction Inbound -Protocol TCP -LocalPort 445 -Action Allow
```

### **Summary:**

1. **Domain Join:** Join your Server Core to the domain using PowerShell.
2. **Static IP:** Set a static IP for consistent network configuration.
3. **SMB Share:** Create and configure an SMB share with appropriate permissions.
4. **Firewall:** Ensure the firewall allows SMB traffic.

These steps should help you successfully configure your Server Core VM as a file server with an SMB share.