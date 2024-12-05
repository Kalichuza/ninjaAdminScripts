# File Monitoring with AuditPol

Monitoring file access is crucial for maintaining the security and integrity of sensitive data. With **AuditPol**, you can configure auditing for specific files and directories to capture read, write, delete, and other access events. This is particularly useful for tracking unauthorized access attempts or ensuring compliance with organizational policies.

### Overview of File Monitoring with AuditPol

**File monitoring** can be configured using **Object Access** auditing settings in `AuditPol`. It involves using **System Access Control Lists (SACLs)** to define which events should be logged for a given resource (like a file or folder). To start monitoring files or directories, you will need to:

1. **Enable the Object Access category in AuditPol**.
2. **Set SACLs** for the specific file or directory you want to monitor.

### Step-by-Step Guide to File Monitoring with AuditPol

#### Step 1: Enable Object Access Auditing
First, you need to enable auditing for **Object Access** at the policy level. This will ensure that any configured SACLs will result in audit events being logged.

Run the following commands to enable auditing for both success and failure events related to object access:

```powershell
# Enable auditing for the Object Access subcategories one by one

# File System auditing
auditpol /set /subcategory:"File System" /success:enable /failure:enable

# Registry auditing
auditpol /set /subcategory:"Registry" /success:enable /failure:enable

# Handle Manipulation auditing
auditpol /set /subcategory:"Handle Manipulation" /success:enable /failure:enable

# File Share auditing
auditpol /set /subcategory:"File Share" /success:enable /failure:enable
```
**Explanation**:
- **/subcategory** specifies which event type you are modifying.
- **/success:enable** enables the auditing of successful events.
- **/failure:enable** enables the auditing of failed events.

If targeting a specific subcategory still fails, you can try enabling auditing for the **entire Object Access category**:

```powershell
auditpol /set /category:"Object Access" /success:enable /failure:enable
```

#### Step 2: Set SACLs on the File or Folder
Once **Object Access** auditing is enabled, you need to define which files or folders you want to monitor. This involves setting a **System Access Control List (SACL)** for the target file or folder. You can do this using the **File Explorer** GUI or via **PowerShell** with the **`icacls`** command.

##### Example Using File Explorer GUI
1. **Right-click** the file or folder you want to monitor.
2. Select **Properties** > **Security** tab > **Advanced**.
3. Click on the **Auditing** tab.
4. Click **Add**, then specify the type of access (e.g., Full Control, Modify, etc.) and users/groups you want to audit.

##### Example Using PowerShell (`icacls`)
You can use the `icacls` command to set an SACL for the file or directory.

To add an auditing entry to a specific file, use:

```powershell
icacls "C:\example\sensitivefile.txt" /setaudit D:(A;;FA;;;S-1-1-0)
```
**Explanation**:
- **D:**: Denotes a new auditing rule.
- **A**: Audit for **All** access.
- **FA**: Full Access permission.
- **S-1-1-0**: Represents the **Everyone** group. This can be adjusted to a specific user or group.

#### Step 3: View the Audited Events
Once the policy is enabled and SACLs are in place, events will be logged whenever someone accesses the monitored file or folder. You can find these events in the **Event Viewer**.

To view file access events:
1. Open **Event Viewer**.
2. Navigate to **Windows Logs** > **Security**.
3. Look for **Event ID 4663** (An attempt was made to access an object).
   - This event will show details such as **who** accessed the file, **what type** of access was attempted (read, write, etc.), and **when** the access occurred.

### Understanding File Access Event IDs
Here are some important event IDs related to **Object Access** that will be helpful for monitoring file activity:
- **Event ID 4656**: A handle to an object was requested. This event is triggered when a user or process attempts to access a file or folder.
- **Event ID 4663**: An attempt was made to access an object. This is the most relevant event for determining what action was taken on a file.
- **Event ID 4658**: The handle to an object was closed. It indicates that the user or process is done accessing the file.

These event logs contain valuable information, such as the **user account** responsible for the action, the **file path**, and the **type of access** (e.g., Read, Write, Delete).

### Example Use Cases for File Monitoring
1. **Monitoring Sensitive Files**: Configure auditing on a file containing sensitive customer information to track any read or write access.
2. **Detecting Unauthorized Access**: Enable auditing on configuration files for critical systems to identify when unauthorized changes are attempted.
3. **Data Leak Prevention**: Track access to folders containing proprietary business information to prevent unauthorized copying or modification.

### Best Practices for File Monitoring
1. **Audit Specific Files and Folders**: To avoid generating overwhelming log data, target only those files and folders that are truly critical.
2. **Review Logs Regularly**: File access logs can accumulate quickly, so it's important to set up regular review procedures or automated tools that can alert you to suspicious activity.
3. **Use Group Policies for Consistency**: For domain-joined machines, use **Group Policy** to ensure consistent auditing configurations across all relevant computers.
4. **Limit SACL Entries**: Audit only those permissions that matter. If you only need to monitor write attempts, auditing full control could generate unnecessary data.

### Automating File Monitoring with PowerShell
For larger environments, you may want to automate file monitoring setup using PowerShell. Here is a script that can be used to automate enabling **Object Access** auditing and setting up SACLs for multiple files or folders:

```powershell
# Enable Object Access auditing
# Set auditing for specific Object Access subcategories

auditpol /set /subcategory:"File System" /success:enable /failure:enable

# Set auditing for specific files or directories
$filesToMonitor = @("C:\example\file1.txt", "C:\example\folder1")
foreach ($file in $filesToMonitor) {
    icacls $file /setaudit D:(A;;FA;;;S-1-1-0)
    Write-Output "Auditing set for $file"
}
```
This script enables **Object Access** auditing and sets up file monitoring for the paths defined in `$filesToMonitor`. You can modify the access types and user/group as per your requirements.

### Summary
File monitoring with **AuditPol** is a powerful way to maintain security and detect unauthorized access to critical resources. The key steps involve enabling **Object Access** auditing, setting SACLs on the resources to be monitored, and analyzing the resulting audit logs in **Event Viewer**. By carefully configuring these policies, you can significantly improve visibility over file access in your environment, ensuring that you are alerted to any suspicious activity.

If you have any specific scenarios you'd like to explore or need additional help setting up file monitoring, feel free to ask!

