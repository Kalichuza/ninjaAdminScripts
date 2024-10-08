Here is a comprehensive guide on how to back up and restore Active Directory (AD) on a domain controller (DC), particularly focusing on handling Hyper-V virtual machines. This guide covers both creating a system state backup and restoring it in the event of a DC failure.

### Step 1: Back Up the Active Directory Domain Controller

To ensure you can restore your Active Directory in the event of a failure, you'll need to create a system state backup of the domain controller.

#### 1.1. **Install the Windows Server Backup Feature**

Start by installing the Windows Server Backup feature using PowerShell:
```powershell
Install-WindowsFeature -Name Windows-Server-Backup
```

#### 1.2. **Create a System State Backup**

Create a system state backup using the `wbadmin` tool. Make sure you specify a backup location with sufficient space (replace `D:` with your desired backup location):
```powershell
wbadmin start systemstatebackup -backuptarget:D: -quiet
```

This command will create a backup of the system state, including:
- Active Directory Domain Services (NTDS.dit database)
- SYSVOL directory
- Registry
- Boot files and system files

### Step 2: Restoring the Active Directory Domain Controller

If your DC fails and you need to restore it, follow these steps to get it back up and running.

#### 2.1. **Reinstall the Operating System**

Reinstall the same version of Windows Server that the original DC was running. Ensure that the new server has the same hostname and IP address as the original DC to avoid complications.

#### 2.2. **Install the Active Directory Domain Services (AD DS) Role**

Use the following PowerShell command to install the AD DS role:
```powershell
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
```

Do not promote the server to a domain controller at this point.

### Step 3: Booting into Directory Services Restore Mode (DSRM) on a Hyper-V VM

Since the DC is a Hyper-V VM, you need to boot into Directory Services Restore Mode. You can do this using either of the two methods below.

#### Method 1: Use the `bcdedit` Command

1. **Set the Boot Configuration to DSRM**:
   ```powershell
   bcdedit /set safeboot dsrepair
   ```

2. **Restart the VM**:
   ```powershell
   Restart-Computer
   ```

3. The server will now boot into Directory Services Restore Mode.

#### Method 2: Modify Boot Settings via Hyper-V Manager

1. Open **Hyper-V Manager**.
2. Right-click on the VM and select **Settings**.
3. Go to **Firmware**.
4. Set the **Startup delay** to `5000 milliseconds` (5 seconds) to give yourself time to press F8.
5. Restart the VM and press F8 during the boot process to enter Directory Services Restore Mode manually.

### Step 4: Restore the System State

Once the server is in Directory Services Restore Mode, proceed with the system state recovery.

1. **Run the System State Recovery Command**:
   ```powershell
   wbadmin start systemstaterecovery -version:<BackupVersion> -reboot
   ```
   Replace `<BackupVersion>` with the specific version of the backup you want to restore.

2. The system will restore the system state and reboot automatically.

### Step 5: Clean Up and Promote to Domain Controller

After the system has rebooted, do the following:

1. **Remove the Safeboot Setting**:
   ```powershell
   bcdedit /deletevalue safeboot
   ```

2. **Restart the Server**:
   ```powershell
   Restart-Computer
   ```

3. **Promote the Server to a Domain Controller**:
   Once the server is back online and the system state is restored, you can promote it to a domain controller. Use the `Install-ADDSForest`, `Install-ADDSDomainController`, or other relevant cmdlets based on your setup.

### Step 6: Verify AD Health and Replication

Once the domain controller is back online, verify that Active Directory is functioning correctly:
1. **Check the health of the AD replication**:
   ```powershell
   repadmin /replsummary
   ```

2. **Verify the status of the Domain Controller**:
   ```powershell
   dcdiag
   ```

3. Ensure that time synchronization is properly configured to avoid Kerberos issues.

### Best Practices and Additional Considerations

- **Multiple Domain Controllers**: Always have at least two domain controllers to ensure high availability and reduce the impact of a single point of failure.
- **FSMO Roles**: Ensure that FSMO roles are properly redistributed if the DC holding them fails. You might need to seize these roles to another DC before restoring.
- **Regular Backups**: Schedule regular backups of your domain controllers to keep your Active Directory safe.
- **Test Restores**: Periodically test the restoration process on a non-production server to ensure your backups are functional.

### Conclusion

This guide provides a step-by-step approach to back up and restore Active Directory on a domain controller using system state backups. For Hyper-V VMs, it's essential to know how to boot into Directory Services Restore Mode using either PowerShell commands or Hyper-V Manager settings. Following these steps ensures that you can quickly restore your AD environment in case of a domain controller failure.
