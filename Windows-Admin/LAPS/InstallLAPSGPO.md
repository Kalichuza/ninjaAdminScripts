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

Certainly! Here are the updated instructions for setting up permissions on a new LAPS installation, including the correction regarding the correct use of cmdlets from the `AdmPwd.PS` module.

### **Step 2: Steps to Set Up LAPS Permissions**

#### Step 1: Install the LAPS Components
1. **Download and Install LAPS:**
   - Download the LAPS installer from the [Microsoft Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=46899).
   - Install the LAPS tools (ensure both management tools and Group Policy files are selected during installation).

2. **Extend the Active Directory Schema:**
   - To extend the Active Directory schema with the necessary attributes for LAPS, run the following command from a Domain Controller or a machine with the Active Directory module installed:
     ```powershell
     Import-Module AdmPwd.PS
     Update-AdmPwdADSchema
     ```
   - This will add the necessary attributes (`ms-Mcs-AdmPwd` and `ms-Mcs-AdmPwdExpirationTime`) to the AD schema.

#### Step 2: Configure Permissions for LAPS

1. **Set Self-Permission for Computers to Update Their Own Passwords:**
   - LAPS requires each computer to have the ability to update its own `ms-Mcs-AdmPwd` and `ms-Mcs-AdmPwdExpirationTime` attributes. To set this permission for all computers in a specific Organizational Unit (OU):
     ```powershell
     Set-AdmPwdComputerSelfPermission -OrgUnit "OU=ManagedComputers,DC=domain,DC=local"
     ```
   - Replace `"OU=ManagedComputers,DC=domain,DC=local"` with the appropriate distinguished name (DN) of your target OU.

2. **Grant Read Permission to IT Admins for Password Retrieval:**
   - You need to give specific users or groups permission to read the `ms-Mcs-AdmPwd` attribute (the password) for computers in the target OU. This can be done using the `Set-AdmPwdReadPasswordPermission` cmdlet. For example, to give the "Domain Admins" group permission to read local administrator passwords:
     ```powershell
     Set-AdmPwdReadPasswordPermission -OrgUnit "OU=ManagedComputers,DC=domain,DC=local" -AllowedPrincipals "Domain Admins"
     ```
   - Replace `"Domain Admins"` with other security groups or users as needed.

3. **Grant Reset Permission for Local Administrator Passwords:**
   - Grant specific users or groups permission to reset the local administrator password if necessary. Use the `Set-AdmPwdResetPasswordPermission` cmdlet:
     ```powershell
     Set-AdmPwdResetPasswordPermission -OrgUnit "OU=ManagedComputers,DC=domain,DC=local" -AllowedPrincipals "Domain Admins"
     ```
   - This ensures that only authorized personnel can manually reset the local administrator password on target machines.

#### Step 3: Deploy and Configure LAPS Group Policy

1. **Create or Modify the Group Policy Object (GPO):**
   - Open **Group Policy Management** from a machine that has the LAPS management tools installed.
   - Either create a new GPO or modify an existing one that is linked to the OU where your computers reside.
   - Navigate to:  
     `Computer Configuration -> Policies -> Administrative Templates -> LAPS`.
   - Configure the following settings:
     - **Enable local admin password management**: Enable this setting to allow LAPS to manage the local administrator password.
     - **Do not allow password expiration time longer than required by policy**: This setting ensures that the password expiration complies with your organization's security policy.
     - **Name of administrator account to manage**: Optionally specify the name of the local administrator account if it differs from the default "Administrator."

2. **Link the GPO to the Appropriate OU:**
   - Ensure that the GPO is linked to the Organizational Unit (OU) containing the computers that you want LAPS to manage.

#### Step 4: Verify Permissions and Test LAPS

1. **Verify LAPS Permissions:**
   - To verify that the correct permissions have been applied, use the `Find-AdmPwdExtendedRights` cmdlet:
     ```powershell
     Find-AdmPwdExtendedRights -Identity "OU=ManagedComputers,DC=domain,DC=local"
     ```
   - This will display a list of users or groups that have been granted permission to read or reset local administrator passwords for computers in the OU.

2. **Test Password Retrieval:**
   - On a machine that has permission to read the password (e.g., a member of the "Domain Admins" group), run the following command to retrieve the local administrator password for a specific computer:
     ```powershell
     Get-AdmPwdPassword -ComputerName "ComputerName"
     ```
   - This will return the local administrator password and the password expiration time.

#### Step 5: Monitor and Maintain LAPS

1. **Regularly Review Permissions:**
   - Periodically check the extended rights using the `Find-AdmPwdExtendedRights` cmdlet to ensure that only authorized groups or users have access to the local administrator passwords.

2. **Rotate Administrator Passwords:**
   - If needed, you can manually reset the password for a specific machine using the `Reset-AdmPwdPassword` cmdlet:
     ```powershell
     Reset-AdmPwdPassword -ComputerName "ComputerName"
     ```

### Summary of Commands

- Extend the AD schema:
  ```powershell
  Update-AdmPwdADSchema
  ```

- Set self-permission for computers:
  ```powershell
  Set-AdmPwdComputerSelfPermission -OrgUnit "OU=ManagedComputers,DC=domain,DC=local"
  ```

- Grant read permissions:
  ```powershell
  Set-AdmPwdReadPasswordPermission -OrgUnit "OU=ManagedComputers,DC=domain,DC=local" -AllowedPrincipals "Domain Admins"
  ```

- Grant reset permissions:
  ```powershell
  Set-AdmPwdResetPasswordPermission -OrgUnit "OU=ManagedComputers,DC=domain,DC=local" -AllowedPrincipals "Domain Admins"
  ```

- Verify extended rights:
  ```powershell
  Find-AdmPwdExtendedRights -Identity "OU=ManagedComputers,DC=domain,DC=local"
  ```

- Retrieve a computer’s password:
  ```powershell
  Get-AdmPwdPassword -ComputerName "ComputerName"
  ```

By following these steps, you will successfully set up permissions for LAPS in your environment, ensuring that passwords are securely stored and only accessible by authorized users.



### **Step 3: Create a Group Policy Object (GPO)** for Software Deployment

1. **Open Group Policy Management Console (GPMC)**:
   - On a domain controller or management workstation, open **Group Policy Management**.

2. **Create a New GPO**:
   - Right-click on the **Organizational Unit (OU)** that contains the computers where you want to install LAPS, and select **Create a GPO in this domain, and Link it here**.
   - Name the new GPO, for example, `LAPS Deployment`.

3. **Edit the GPO**:
   - Right-click the new **LAPS Deployment** GPO and select **Edit**.

---

### **Step 4: Configure the GPO for Software Installation**

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

### **Step 5: Link the GPO to the Correct OU**

1. **Link the GPO** to the **Organizational Unit (OU)** that contains the computers where LAPS should be installed.

   For example, if the computers are in the `ManagedComputers` OU, right-click the `ManagedComputers` OU and choose **Link an Existing GPO**. Select the **LAPS Deployment** GPO.

---

### **Step 6: Force Group Policy Update and Verify Installation**

1. On the target computers, you can force a Group Policy update by running:

   ```powershell
   gpupdate /force
   ```

2. **Restart the Computers**:
   The software installation will take place when the computers restart. After rebooting, the LAPS client will be installed.

---

### **Step 7: Verify LAPS Installation**

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

### **Step 8: Apply LAPS Configuration through Group Policy**

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
