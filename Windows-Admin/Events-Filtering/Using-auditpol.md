# Comprehensive Guide to Using AuditPol

**AuditPol** is a command-line tool for managing and viewing audit policies in Windows. It allows administrators to configure security audit policies for local or remote systems and provides fine-grained control over auditing settings.

### What is AuditPol?
AuditPol is part of Windows and is used to set and get the audit security policy to determine which security events are logged. You can use it to define policies that monitor different kinds of system activity like user logons, file access, policy changes, and more. It allows more detailed control compared to the GUI-based Local Security Policy editor.

### AuditPol Basic Command Structure

The general syntax of the `AuditPol` command is:
```bash
AuditPol /<command> <sub-command/options>
```
The main commands are:
- **/get**: Displays the current audit policy.
- **/set**: Sets or modifies the audit policy.
- **/list**: Displays the list of available audit policy subcategories.
- **/backup**: Saves the audit policy to a file.
- **/restore**: Restores the audit policy from a backup file.
- **/clear**: Clears the audit policy settings.
- **/remove**: Removes per-user audit policy settings.
- **/resourceSACL**: Configures global resource SACLs.

### How to List Audit Categories and Subcategories
To view a list of available audit policy categories and subcategories:
```powershell
auditpol /list /category:*
```
This command will display categories like **Logon/Logoff**, **Object Access**, **Policy Change**, etc. Each category will have subcategories, e.g., **Logon/Logoff** contains **Logon**, **Logoff**, **Special Logon**, etc.

### Viewing Current Audit Policies
To view the current audit policy configuration on the machine:
```powershell
auditpol /get /category:*
```
This will display the audit policies for all categories and subcategories.

### Viewing Specific Audit Policy Settings
To view the current audit settings for a specific category, for example, **Logon/Logoff**:
```powershell
auditpol /get /category:"Logon/Logoff"
```
This will show you if auditing for **Success** or **Failure** events is enabled for subcategories like **Logon** and **Logoff**.

### Setting Audit Policies
You can enable or disable auditing for specific categories or subcategories. For example, to enable auditing for successful and failed logon events, use:
```powershell
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
```
**Explanation**:
- **/subcategory** specifies which event type you are modifying.
- **/success:enable** enables the auditing of successful events.
- **/failure:enable** enables the auditing of failed events.

You can also set auditing for multiple subcategories by running multiple `auditpol /set` commands.

### Examples of Setting Audit Policies
1. **Enable Logon Auditing**
   ```powershell
   auditpol /set /subcategory:"Logon" /success:enable /failure:enable
   ```
   This command will enable auditing for both successful and failed logon attempts.

2. **Enable Logoff Auditing**
   ```powershell
   auditpol /set /subcategory:"Logoff" /success:enable /failure:enable
   ```
   This will track when users log off successfully or unsuccessfully.

3. **Enable Special Logon Auditing**
   ```powershell
   auditpol /set /subcategory:"Special Logon" /success:enable /failure:enable
   ```
   This tracks events like Remote Desktop connections and privilege use that are deemed "special" logons.

### Backup and Restore Audit Policies
AuditPol allows you to backup the current auditing policy and restore it as needed.
- **Backup Policy**: This creates a backup of the audit policies to a file.
  ```powershell
  auditpol /backup /file:C:\backup\auditpolicy.bak
  ```

- **Restore Policy**: This restores the audit policies from a backup file.
  ```powershell
  auditpol /restore /file:C:\backup\auditpolicy.bak
  ```

This is particularly useful for administrators who wish to keep a record of the audit configuration or replicate it across systems.

### Clearing Audit Policies
If you need to clear the current audit policies to reset all settings:
```powershell
auditpol /clear
```
**Note**: Clearing the policy will remove all audit settings, so it is often recommended to create a backup first.

### Configuring Resource SACLs
You can use AuditPol to configure global resource **SACLs** (System Access Control Lists), which are used to audit attempts to access system resources such as files, registry keys, or services.
```powershell
auditpol /resourceSACL /type:file /object:"C:\example.txt" /success:enable /failure:enable
```
In this example, **/type:file** specifies the resource type, and **/object** specifies the file to be audited.

### Common Subcategories and Their Purpose
Below is a list of commonly used audit subcategories and their function:
- **Logon**: Records user logon attempts.
- **Logoff**: Records when users log off.
- **Account Lockout**: Logs when an account becomes locked due to failed login attempts.
- **Special Logon**: Captures logons that involve elevated privileges or special use cases like Remote Desktop.
- **Object Access**: Tracks attempts to access specific objects such as files or registry keys.
- **Policy Change**: Monitors changes to audit policies, security settings, and user rights.
- **Privilege Use**: Records when privileges like `SeShutdownPrivilege` or `SeTakeOwnershipPrivilege` are used.

### Practical Use Cases
1. **Monitoring User Logons**:
   - Enable audit policies for the **Logon** and **Special Logon** subcategories to track who logs on to your systems, when, and how.
2. **Detecting Unauthorized Access Attempts**:
   - Use **Object Access** auditing to track attempts to access sensitive files or folders, enabling you to detect potential unauthorized access.
3. **Policy Change Alerts**:
   - Enable **Policy Change** auditing to ensure you are alerted to any changes in the security configuration of your systems, such as changes to the local security policy or audit policy.

### Troubleshooting Common Issues
1. **Parameter is Incorrect (0x00000057)**:
   - Ensure that the subcategory name matches exactly as it appears in `auditpol /list /subcategory:*`.
   - If the command fails, re-check the subcategory spelling or try running `auditpol` as an administrator.

2. **No Matching Events**:
   - If no events are being logged, verify the audit policy settings are enabled by using `auditpol /get /category:*`.
   - Make sure that auditing is also configured correctly through **Local Security Policy** or **Group Policy** and not overridden.

### Summary
**AuditPol** is a powerful tool that allows you to configure detailed audit policies on your Windows systems. It helps track various activities and provides enhanced visibility into actions taken by users or administrators. Understanding how to use `AuditPol` to control auditing policies can help you manage and secure your environment more effectively.

- **/get**: View current policies.
- **/set**: Set specific audit policies for success and failure.
- **/list**: List categories and subcategories.
- **/backup** and **/restore**: Save and restore audit settings.

Utilizing `AuditPol` is essential for maintaining compliance, monitoring for security threats, and troubleshooting issues across a Windows environment.

