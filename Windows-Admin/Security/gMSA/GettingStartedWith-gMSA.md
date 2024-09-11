Here’s a **step-by-step guide** for setting up a **Group Managed Service Account (gMSA)** to replace a one-off account like `scanuser` in an environment. This setup guide includes creating the gMSA, configuring it for use with a specific server, and configuring the MFP (Multi-Function Printer) to use the gMSA for scanning to a network share. I’ve sanitized any real domain or server names.

### **Step-by-Step Setup for gMSA (Sanitized)**

---

### **1. Prerequisites**

Before proceeding, ensure the following prerequisites are met:
1. **Domain Functional Level**: The domain must be running at **Windows Server 2012** or higher.
2. **Key Distribution Service (KDS)**: The KDS root key must be created if this is your first time setting up gMSAs.

#### **1.1 Create the KDS Root Key (If Not Already Created)**

Run this command on a **Domain Controller** to create the KDS root key, which allows the domain controller to generate and distribute gMSA passwords:

```powershell
Add-KdsRootKey -EffectiveImmediately
```

If you have multiple Domain Controllers and want to allow time for replication, use the following to account for a 10-hour replication delay:

```powershell
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
```

---

### **2. Create the gMSA**

Now, create the gMSA that will replace the `scanuser` account. This account will be used for a network scanning service (such as on an MFP device). The gMSA will be assigned to a specific server, `SCAN-SERVER01` in this example.

#### **2.1 Create the gMSA**

Run the following command on a **Domain Controller** or workstation with AD PowerShell module installed to create the gMSA. Replace values as needed:

```powershell
New-ADServiceAccount -Name gMSAScanUser -DNSHostName "domain.local" -PrincipalsAllowedToRetrieveManagedPassword "SCAN-SERVER01$"
```

- **`-Name`**: The name of the new gMSA (e.g., `gMSAScanUser`).
- **`-DNSHostName`**: The domain’s FQDN (e.g., `domain.local`).
- **`-PrincipalsAllowedToRetrieveManagedPassword`**: This specifies which computers (or security groups) are allowed to retrieve the gMSA password. In this case, we are allowing the server `SCAN-SERVER01` to use this gMSA. Don't forget the `$` after the computer name.

---

### **3. Install the gMSA on the Target Server**

Next, install the gMSA on the target server (e.g., `SCAN-SERVER01`), where the gMSA will be used for accessing the network share.

1. **Log in to `SCAN-SERVER01`** and open **PowerShell as Administrator**.

2. Run the following command to install the gMSA on the server:

   ```powershell
   Install-ADServiceAccount -Identity gMSAScanUser
   ```

3. **Verify the gMSA installation** by running the following command:

   ```powershell
   Test-ADServiceAccount -Identity gMSAScanUser
   ```

   This command should return `True` if the gMSA is properly installed and functioning.

---

### **4. Configure the MFP or Application to Use the gMSA**

Next, configure the MFP (Multi-Function Printer) or any application to use the newly created gMSA for scanning to a network share.

#### **4.1 Configure the Network Share Permissions**

Ensure that the gMSA has access to the network share where scanned documents will be saved.

1. Right-click the shared folder (e.g., `\\fileserver\scans`) and go to **Properties** > **Security** tab.
2. Click **Edit** and add the gMSA (e.g., `domain\gMSAScanUser$`).
3. Set permissions such as **Modify** or **Full Control** as needed.

#### **4.2 Update the MFP’s Scan Profile (Using the Web GUI)**

1. Open the MFP’s **Web GUI** by entering the device’s IP address in a browser (e.g., `http://<MFP-IP-Address>`).
2. Navigate to the **Scan Profile** or **Scan to Network** settings (this might be under **Scan** > **Scan to Folder**).
3. In the **credentials** section of the profile, update the following:
   - **Username**: Enter the gMSA as:
     ```
     domain\gMSAScanUser$
     ```
   - **Password**: Leave the password field **blank**. Since gMSAs are managed by the domain, no password needs to be entered manually.
4. Save the settings.

---

### **5. Test the Setup**

Now, test the setup to ensure everything is working correctly:

1. On the MFP, scan a document using the newly configured scan profile.
2. Ensure the document is saved successfully in the network share (e.g., `\\fileserver\scans`).
3. Check the **MFP logs** or status page for any errors related to authentication or network access.
4. If there are any issues, verify:
   - The gMSA has the necessary permissions on the network share.
   - The MFP’s scan profile is correctly configured with the gMSA.
   - The gMSA is installed and functional on the `SCAN-SERVER01` server.
5. you can also run the below script to manually test fucntionality:
  
---
 ```powershell
   $path = "\\Path\To\Net\Share"
if (Test-Path $path) {
    Write-Host "Access to network share successful."
} else {
    Write-Host "Failed to access network share."
}
   ```


### **6. Optional: Add More Servers (If Needed)**

If you need to allow more servers to retrieve the gMSA password, you can update the gMSA configuration to include additional servers or groups.

#### **6.1 Add Additional Computers to gMSA Permissions**

You can add additional servers using the `Set-ADServiceAccount` cmdlet. For example, to allow both `SCAN-SERVER01` and `SCAN-SERVER02` to retrieve the gMSA password:

```powershell
Set-ADServiceAccount -Identity gMSAScanUser -PrincipalsAllowedToRetrieveManagedPassword "SCAN-SERVER01$", "SCAN-SERVER02$"
```

---

### **Summary of Steps**:
1. **Create the KDS root key** (if not already created).
2. **Create the gMSA** with the correct permissions for the server.
3. **Install the gMSA** on the target server.
4. **Configure the network share** to allow the gMSA access.
5. **Update the MFP** or application to use the gMSA.
6. **Test the setup** by scanning to the network folder.

By following these steps, you can securely replace manual service accounts like `scanuser` with a **Group Managed Service Account (gMSA)**, improving security and simplifying management.
