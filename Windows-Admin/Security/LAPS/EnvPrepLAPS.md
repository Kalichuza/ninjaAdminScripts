

## ENV Prep:

If you do not already have a managed computers OU you can move all your pcs to a new one like this 

Moving computer objects to a new Organizational Unit (OU) in Active Directory typically does not have an immediate impact on end users. However, changes may affect the users indirectly if:

1. **Group Policy Objects (GPOs)** applied to the new OU differ from the old location.
2. Any permissions, delegation, or other AD-based configurations tied to the original location are altered.

### To minimize impact:
- Ensure that any GPOs applied to the new OU are compatible with the users' environment.
- Plan and test the changes in a staging environment before moving production machines.

### Steps to Create an Organizational Unit and Move Computers There

Here’s a step-by-step guide for creating an OU, moving computer objects, and applying LAPS:
import the laps module
```powershell
Import-Module AdmPwd.PS
```
---

### **Step 1: Create the Organizational Unit**

Use the following PowerShell command to create a new OU for the computers:

```powershell
New-ADOrganizationalUnit -Name "ManagedComputers" -Path "DC=<YourDomain>,DC=local"
```

This command creates an OU called "ManagedComputers" under your domain `DC=<YourDomain>,DC=local`. You can adjust the name and path as per your organizational structure.

---

### **Step 2: Move Computers to the New OU**

To move computer objects from the default **Computers** container to the new **ManagedComputers** OU, run the following command for each computer or use a loop for bulk moves.

**Move a single computer**:

```powershell
Move-ADObject -Identity "CN=ComputerName,CN=Computers,DC=<YourDomain>,DC=local" -TargetPath "OU=ManagedComputers,DC=<YourDomain>,DC=local"
```

**Move multiple computers (bulk move)**:

You can list all computers in the **Computers** container and move them:

```powershell
Get-ADComputer -SearchBase "CN=Computers,DC=<YourDomain>,DC=local" -Filter * | ForEach-Object {
    Move-ADObject -Identity $_.DistinguishedName -TargetPath "OU=ManagedComputers,DC=<YourDomain>,DC=local"
}
```

This command moves all computers in the **Computers** container to the new **ManagedComputers** OU.

---

### **Step 3: Apply LAPS Permissions to the New OU**

Once the computers are in the new OU, you need to apply the necessary permissions for LAPS:

You might have to check the location of the OU, here's how:
```powershell
Get-ADOrganizationalUnit -Filter 'Name -eq "ManagedComputers"' | Select Name, DistinguishedName
```

```powershell
Set-AdmPwdComputerSelfPermission -OrgUnit "OU=ManagedComputers,DC=<YourDomain>,DC=local"
Set-AdmPwdReadPasswordPermission -OrgUnit "OU=ManagedComputers,DC=<YourDomain>,DC=local" -AllowedPrincipals "Domain Admins"
```

---

### **Step 4: Update Group Policy**

Ensure that any **Group Policy Objects (GPOs)** necessary for managing LAPS or any other configuration (e.g., security policies) are linked to the new **ManagedComputers** OU.

- Open **Group Policy Management Console (GPMC)**.
- Right-click the **ManagedComputers** OU and link your GPOs.
- Run `gpupdate /force` on the client computers to apply the new GPOs immediately.

---

### **Step 5: Testing and Monitoring**

1. **Test GPO Application**: Ensure the appropriate GPOs are applied to the new OU by running the following on a test machine:
   ```powershell
   gpresult /r
   ```

2. **Monitor End Users**: Users typically won’t experience disruption unless new or different GPOs are applied, which might change their login experience, security settings, or access to shared resources.

---

### **Impact on End Users**

If the new OU has the same GPOs or similar configurations to the previous location, **there should be little to no impact** on end users. However, any changes to GPOs that impact login times, desktop environments, or application access might result in some changes for end users.

Examples of potential impacts:
- **Login times** may be affected if there are new login scripts or settings.
- **Network drive mappings** may change if group policies related to drives differ.
- **Security settings** may impact access to shared resources, printers, etc.

It’s a good idea to notify users of any anticipated changes in advance if the move is expected to introduce noticeable differences in their environment.

---

### **Summary of Steps**

1. Create the new **OU** (`New-ADOrganizationalUnit`).
2. Move computers into the new **OU** (`Move-ADObject`).
3. Apply LAPS permissions (`Set-AdmPwdComputerSelfPermission`).
4. Link the necessary **GPOs** to the new OU.
5. Test and monitor for any potential end-user impacts.

By carefully planning and testing, you can avoid any major disruptions to end users while managing LAPS more effectively.

Let me know if you'd like further assistance!
