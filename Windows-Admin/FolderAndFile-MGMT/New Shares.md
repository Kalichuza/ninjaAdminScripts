
Here's how you can achieve both tasks step-by-step in PowerShell:

---

### **Step 1: Set ACLs for Specific Users**

Use the `Set-Acl` cmdlet to grant full access to specific users on a folder. Replace `<FolderPath>` with the folder path and `<Username>` with the desired username(s).

#### Example Command:

```powershell
$FolderPath = "C:\YourSharedFolder"
$userName = "DOMAIN\YourUsername"

# Get the current ACL of the folder
$Acl = Get-Acl $FolderPath

# Define a new access rule
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($userName, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

# Add the access rule to the ACL
$Acl.SetAccessRule($AccessRule)

# Apply the modified ACL to the folder
Set-Acl -Path $FolderPath -AclObject $Acl
```


```powershell
$FolderPath = "C:\YourSharedFolder"
$GroupName = "DOMAIN\YourSecurityGroup"  # Replace with your security group name

# Get the current ACL of the folder
$Acl = Get-Acl $FolderPath

# Define a new access rule for the group
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($GroupName, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")

# Add the access rule to the ACL
$Acl.SetAccessRule($AccessRule)

# Apply the modified ACL to the folder
Set-Acl -Path $FolderPath -AclObject $Acl
```
You can repeat this for additional users by modifying the `$Username` variable or add multiple access rules as needed.

---

### **Step 2: Create an SMB Share**

Use the `New-SmbShare` cmdlet to create a shared folder and restrict access to specific users.

#### Example Command:

```powershell
$ShareName = "YourShareName"
$FolderPath = "C:\YourSharedFolder"
$FullAccessUsers = "DOMAIN\YourUsername1", "DOMAIN\YourUsername2"

# Create the SMB share
New-SmbShare -Name $ShareName -Path $FolderPath -FullAccess $FullAccessUsers
```

- Replace `YourShareName` with the name of the share.
- Replace `DOMAIN\YourUsername1` and `DOMAIN\YourUsername2` with the usernames of those you want to have access.

---

### **Step 3: Verify Share and Permissions**

After setting up the share, you can verify its existence and permissions using:

#### Verify SMB Shares:

```powershell
Get-SmbShare
```

#### Verify Permissions:

```powershell
Get-Acl -Path $FolderPath | Format-List
```

---

Would you like assistance tailoring these commands to your specific use case or testing the setup?