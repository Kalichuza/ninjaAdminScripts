You can replace "one-off" accounts like `printuser@<yourDomain>.local` with **Group Managed Service Accounts (gMSA)** to enhance security and simplify password management. A **gMSA** provides automatic password management, making it an ideal replacement for manually managed service accounts like `printuser@<yourDomain>.local`.

### **Steps to Implement Group Managed Service Accounts (gMSA)**

---

### **1. Prerequisites**
Before creating and using gMSAs, ensure that the following conditions are met:
- **Domain Functional Level**: The domain must be running at **Windows Server 2012** or higher functional level.
- **Key Distribution Service (KDS)**: The KDS root key must be created on the domain to enable password management for gMSAs.

### **2. Create the KDS Root Key (If Not Already Created)**

If this is your first time setting up gMSAs, you need to create the **KDS root key**, which allows the domain controller to generate passwords for gMSAs.

1. Open PowerShell as an administrator on a **Domain Controller**.

2. Run the following command to create the KDS root key:
   
   ```powershell
   Add-KdsRootKey -EffectiveImmediately
   ```

   If you have a multi-domain controller environment, you can specify a replication delay (typically 10 hours) to ensure the key propagates to all DCs:
   
   ```powershell
   Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
   ```

---

### **3. Create the gMSA**

Once the KDS root key is set up, you can create the gMSA.
Incase you need to setup a nre OU for the service account:

```powershell
New-ADOrganizationalUnit -Name "ScanUsers" -Path "DC=<yourDomain>,DC=local"

```
1. **Open PowerShell as a Domain Administrator**.

2. Use the following command to create the gMSA. Replace `"gMSAPrintUser"` with the desired name for the gMSA, and modify the DNS hostname and security group accordingly:

   ```powershell
   New-ADServiceAccount -Name gMSAPrintUser -DNSHostName "<yourDomain>.local" -PrincipalsAllowedToRetrieveManagedPassword "<yourDomain>\PrintServerGroup"
   ```

   - **`-Name`**: Specifies the name of the gMSA (e.g., `gMSAPrintUser`).
   - **`-DNSHostName`**: The fully qualified domain name (FQDN) of the domain where the account will be used.
   - **`-PrincipalsAllowedToRetrieveManagedPassword`**: Specifies which computers or security groups are allowed to retrieve the gMSA's password. You can add the group of servers that will use this account (e.g., `<yourDomain>\PrintServerGroup`).

---

### **4. Install the gMSA on the Target Machine(s)**

You need to install the gMSA on the machines that will use it. These could be servers running services like printing, web servers, or any other service where you're replacing the old service account.

1. On the target machine, open **PowerShell as Administrator**.

2. Run the following command to install the gMSA:
   
   ```powershell
   Install-ADServiceAccount -Identity gMSAPrintUser
   ```

3. Verify that the gMSA is installed by running:

   ```powershell
   Test-ADServiceAccount gMSAPrintUser
   ```

   This command should return `True` if the gMSA is installed correctly and functioning as expected.

---

### **5. Configure the Service to Use the gMSA**

Now, you need to configure the service (e.g., printing) to use the newly created gMSA instead of `printuser@<yourDomain>.local`.

1. Open the **Services** console (`services.msc`).
2. Find the service that is currently using the `printuser@<yourDomain>.local` account (e.g., Print Spooler or a custom print service).
3. Right-click the service and select **Properties**.
4. In the **Log On** tab, change the logon account to the gMSA by specifying the account as follows:
   
   ```
   DOMAIN\gMSAPrintUser$
   ```

   Make sure to include the **`$`** symbol at the end of the gMSA name.

5. **Do not enter a password**—the password for the gMSA is automatically managed by the domain.

6. Click **OK** and restart the service.

---

### **6. Verify gMSA Usage**

After configuring the service to use the gMSA, verify that the service is functioning properly:
- Ensure that the service is running and logs show no authentication issues.
- Check the **Windows Event Log** for any errors related to service logon.

---

### **7. Additional Considerations for Multi-Host Services**

If you're using the gMSA across multiple hosts (e.g., multiple print servers), ensure that:
- The **`-PrincipalsAllowedToRetrieveManagedPassword`** parameter includes all the hosts (or a security group containing the hosts) that will be allowed to use the gMSA.

For example, if you have multiple print servers:
```powershell
New-ADServiceAccount -Name gMSAPrintUser -DNSHostName "<yourDomain>.local" -PrincipalsAllowedToRetrieveManagedPassword "<yourDomain>\PrintServers"
```

Where `<yourDomain>\PrintServers` is a security group containing the allowed computers.

---

### **Benefits of Using gMSA Over Traditional Accounts**:
- **Automatic password management**: No need to manually reset passwords; gMSA passwords are managed by the domain controller.
- **Improved security**: gMSAs have long, complex passwords (120 characters) that change periodically, making them more secure than manually managed accounts.
- **No manual password input**: The gMSA password is not known to users or administrators, reducing the risk of password compromise.

---

### **Summary of Steps**:
1. **Create the KDS Root Key** (if not already created).
2. **Create the gMSA** using `New-ADServiceAccount`.
3. **Install the gMSA** on the target machines.
4. **Configure services** to use the gMSA.
5. **Verify the service** and the account's functionality.

This approach will replace manually managed accounts like `printuser@<yourDomain>.local` with a much more secure and manageable gMSA.

Let me know if you need further details on any step!
