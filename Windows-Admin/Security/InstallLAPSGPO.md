To deploy the LAPS client (the **Local Administrator Password Solution**) through **Group Policy**, you can use the **Group Policy Software Installation** (GPSI) feature to automatically install the LAPS MSI package on your domain-joined computers.

Here’s a step-by-step guide for deploying LAPS via Group Policy:

---

### **Step 1: Prepare the LAPS MSI Package**

1. **Download the LAPS Installer**:
   Download the **LAPS.x64.msi** or **LAPS.x86.msi** package from the [Microsoft website](https://www.microsoft.com/en-us/download/details.aspx?id=46899) if you haven't done so already.

2. **Store the MSI Package on a Network Share**:
   - Place the `LAPS.x64.msi` (or `LAPS.x86.msi` for 32-bit machines) in a network share that is accessible by all computers in your domain.
   - Ensure that **Domain Computers** and **Domain Admins** have **Read** permissions for the network share.

   Example UNC path: `\\yourserver\LAPS\LAPS.x64.msi`


You can configure the permisions for the install path with the following script:
```powershell
# Define the path to the folder
$folderPath = "\\PAth\To\LAPSINSTALLER"

# Get the current ACL
$acl = Get-Acl -Path $folderPath

# Create a new access rule for Domain Computers with Read and Execute permissions
$domainComputers = New-Object System.Security.AccessControl.FileSystemAccessRule("Domain Computers", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")

# Add the new rule to the ACL
$acl.AddAccessRule($domainComputers)

# Apply the updated ACL to the folder
Set-Acl -Path $folderPath -AclObject $acl

Get-Acl -Path $folderPath | Format-List

```
---

### **Step 2: Create a Group Policy Object (GPO)** for Software Deployment

1. **Open Group Policy Management Console (GPMC)**:
   - On a domain controller or management workstation, open **Group Policy Management**.

2. **Create a New GPO**:
   - Right-click on the **Organizational Unit (OU)** that contains the computers where you want to install LAPS, and select **Create a GPO in this domain, and Link it here**.
   - Name the new GPO, for example, `LAPS Deployment`.

3. **Edit the GPO**:
   - Right-click the new **LAPS Deployment** GPO and select **Edit**.

---

### **Step 3: Configure the GPO for Software Installation**

1. In the **Group Policy Management Editor**, navigate to:
   ```
   Computer Configuration > Policies > Software Settings > Software Installation
   ```

2. **Right-click Software Installation**, select **New** > **Package**.

3. **Browse to the LAPS MSI file**:
   - In the **Open** window, enter the **UNC path** to the `LAPS.msi` file. **Do not** use a local drive path (e.g., `C:\`), always use the UNC path (e.g., `\\server\share\LAPS.msi`).
   - Example: `\\yourserver\LAPS\LAPS.x64.msi`

4. **Choose Deployment Method**:
   - When prompted to choose a deployment method, select **Assigned** (not **Published**).

   This ensures that the LAPS client is automatically installed on the target computers during startup.


---

### **Step 4: Link the GPO to the Correct OU**

1. **Link the GPO** to the **Organizational Unit (OU)** that contains the computers where LAPS should be installed.

   For example, if the computers are in the `ManagedComputers` OU, right-click the `ManagedComputers` OU and choose **Link an Existing GPO**. Select the **LAPS Deployment** GPO.

---

### **Step 5: Force Group Policy Update and Verify Installation**

1. On the target computers, you can force a Group Policy update by running:

   ```powershell
   gpupdate /force
   ```

2. **Restart the Computers**:
   The software installation will take place when the computers restart. After rebooting, the LAPS client will be installed.

---

### **Step 6: Verify LAPS Installation**

After rebooting, verify that the LAPS client was installed successfully on the target computers.

1. **Check Installed Programs**:
   - Go to **Control Panel > Programs and Features** on a client machine and verify that **Local Administrator Password Solution** is listed as an installed program.

2. **Check via PowerShell**:
   You can also check if LAPS is installed by running this command on a target machine:

   ```powershell
   Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "Local Administrator Password Solution" }
   ```

   This should return details about the installed LAPS MSI if the installation was successful.

---

### **Step 7: Apply LAPS Configuration through Group Policy**

Once LAPS is installed on the computers, you need to ensure that the **LAPS Group Policy settings** are applied. This is done by creating another GPO to configure LAPS:

1. **Create a New GPO** (if not already created) and configure it for LAPS:
   - Go to **Computer Configuration > Policies > Administrative Templates > LAPS**.
   - Set **Enable local admin password management** to **Enabled**.
   - Configure password length, complexity, and expiration settings according to your requirements.

2. **Link the LAPS GPO** to the correct OUs, ensuring that the computers now managed by LAPS receive these settings.

3. **Force Group Policy Update**:
   Run `gpupdate /force` on the client machines to apply the LAPS settings.

---

### **Optional: Automate LAPS Deployment for Multiple OUs**

If you want to deploy LAPS across multiple OUs, repeat the process by linking the **LAPS Deployment** GPO to each OU where you want to install LAPS.

---

### **Troubleshooting**

- If the software does not install on target machines, ensure:
  - The network share permissions allow **Read** access for the **Domain Computers** group.
  - The UNC path to the MSI file is correct.
  - The Group Policy is linked to the correct OU.
  - The computers are rebooted after receiving the GPO.

- You can also check the **Event Viewer** on the client machine for any errors under **Application Logs > MsiInstaller**.

---

### Summary

By deploying LAPS through Group Policy, you can automate the installation of the LAPS client on domain-joined computers across your organization. After deployment, you can apply LAPS policies via GPO to enforce strong local admin password management.

Let me know if you need further assistance!
