Here’s how you can deploy the `CustomSD` value via Group Policy using Registry Preferences:

### 1. **Open Group Policy Management Console**

1. Open **Group Policy Management Console** (`gpmc.msc`) on your domain controller or a machine with the appropriate administrative tools.

2. Create a new Group Policy Object (GPO) or edit an existing one:
   - Right-click your domain or the Organizational Unit (OU) where you want to apply the policy and select **Create a GPO in this domain, and Link it here** or **Edit** an existing GPO.

### 2. **Navigate to Registry Preferences**

1. In the **Group Policy Management Editor**, go to:
   ```
   Computer Configuration > Preferences > Windows Settings > Registry
   ```

2. Right-click on **Registry**, select **New**, and then choose **Registry Item**.

### 3. **Create Registry Items for Event Logs**

You will create a registry item for each log (Application, Security, and System) where you want to restrict access.

#### a. **Application Log**
1. **Action**: Select **Update**.
2. **Hive**: `HKEY_LOCAL_MACHINE`.
3. **Key Path**: 
   ```
   SYSTEM\CurrentControlSet\Services\EventLog\Application
   ```
4. **Value Name**: `CustomSD`.
5. **Value Type**: `REG_SZ`.
6. **Value Data**: 
   ```
   O:BAG:SYD:(A;;0x1;;;SY)(A;;0x1;;;BA)
   ```

#### b. **Security Log**
1. **Action**: Select **Update**.
2. **Hive**: `HKEY_LOCAL_MACHINE`.
3. **Key Path**: 
   ```
   SYSTEM\CurrentControlSet\Services\EventLog\Security
   ```
4. **Value Name**: `CustomSD`.
5. **Value Type**: `REG_SZ`.
6. **Value Data**: 
   ```
   O:BAG:SYD:(A;;0x1;;;SY)(A;;0x1;;;BA)
   ```

#### c. **System Log**
1. **Action**: Select **Update**.
2. **Hive**: `HKEY_LOCAL_MACHINE`.
3. **Key Path**: 
   ```
   SYSTEM\CurrentControlSet\Services\EventLog\System
   ```
4. **Value Name**: `CustomSD`.
5. **Value Type**: `REG_SZ`.
6. **Value Data**: 
   ```
   O:BAG:SYD:(A;;0x1;;;SY)(A;;0x1;;;BA)
   ```

### 4. **Apply the GPO**

1. After configuring the registry items for each event log, close the Group Policy Management Editor.
2. Ensure the GPO is linked to the appropriate OU or the domain itself.

### 5. **Force Group Policy Update on Client Machines**

To apply the changes immediately, you can force a Group Policy update on client machines:

```powershell
gpupdate /force
```

### 6. **Verify the Changes**

1. After the Group Policy is applied, check the event logs on a client machine to ensure that only administrators can view the logs.
2. You can verify this by attempting to access the event logs as a non-admin user; access should be restricted.

By following these steps, you will have successfully deployed the `CustomSD` registry values via Group Policy, restricting access to the specified event logs to only local or domain administrators.