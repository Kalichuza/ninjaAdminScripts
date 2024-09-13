Yes, you can use **Group Policy** (GPO) to configure and enforce auditing policies in Active Directory. Here's how you can properly configure auditing policies to ensure that important security events are logged:

### Steps to Configure Auditing via GPO:

1. **Open the Group Policy Management Console (GPMC)**:
   - On a domain controller or a machine with administrative tools, open `Group Policy Management`. You can do this by typing `gpmc.msc` in the `Run` dialog (Windows Key + R).

2. **Create or Edit a Group Policy Object**:
   - You can either edit an existing GPO (such as `Default Domain Policy`) or create a new one dedicated to auditing.
   - Right-click on the GPO and select **Edit**.

3. **Navigate to the Audit Policy Settings**:
   - In the **Group Policy Management Editor**, navigate to:
     ```
     Computer Configuration > Policies > Windows Settings > Security Settings > Advanced Audit Policy Configuration > Audit Policies
     ```

4. **Configure Audit Categories**:
   - Expand **Audit Policies** and configure the following categories according to your organization's needs:
     - **Account Logon**: Monitors authentication events.
     - **Account Management**: Logs user account and group management changes (e.g., adding users to Domain Admins).
     - **Logon/Logoff**: Tracks logons and logoffs.
     - **Object Access**: Monitors access to files, folders, registry keys, etc. (This needs to be paired with enabling object auditing on specific resources.)
     - **Policy Change**: Audits changes to audit policies, user rights assignments, and trust policies.
     - **Privilege Use**: Tracks the use of sensitive privileges.
     - **System**: Logs system events like system startup, shutdown, or time changes.

     For example, to audit logon events:
     - Double-click **Logon/Logoff** and enable **Success** and **Failure** for the relevant subcategories (e.g., **Logon**, **Logoff**).
     - Repeat this process for other audit categories based on your security requirements.

5. **Advanced Audit Policy Configuration**:
   - If you prefer more granular control, use the **Advanced Audit Policy Configuration** instead of the standard audit policies. This can be found in the same GPO editor:
     ```
     Computer Configuration > Policies > Windows Settings > Security Settings > Advanced Audit Policy Configuration > System Audit Policies
     ```

   - Here, you'll find more detailed settings under each audit category. For example, in **Account Management**, you can separately configure audits for actions like **User Account Management** or **Group Membership** changes.

6. **Enable Auditing on Specific Objects (if required)**:
   - For **Object Access** auditing, you need to enable auditing for specific files, folders, or registry keys:
     - Right-click on the file/folder, select **Properties**, go to the **Security** tab, and click **Advanced**.
     - Under **Auditing**, add specific users or groups (e.g., everyone) and specify what actions to audit (read, write, delete, etc.).

7. **Apply the GPO**:
   - Once the settings are configured, apply the GPO to the appropriate organizational units (OUs) or the entire domain.

### Verify the Audit Configuration:
After configuring the GPO, you can verify that auditing is properly set up by:
1. Running `gpupdate /force` to apply the new policy.
2. Checking the **Security** event log for the events being generated as per your configuration. These logs can be found in **Event Viewer** under:
   ```
   Event Viewer > Windows Logs > Security
   ```

### Important Considerations:
- **Audit Log Size**: Ensure that the security logs are large enough to store audit events. You can configure this under the same GPO by navigating to:
  ```
  Computer Configuration > Policies > Windows Settings > Security Settings > Event Log > Maximum Log Size
  ```
- **Advanced Audit Policy and Standard Audit Policy Conflict**: If you use both standard and advanced audit policies, be aware that advanced audit policy settings take precedence, and mixing them might lead to inconsistent results.

By following these steps, you can ensure that Active Directory auditing policies are correctly configured, and key security events are being logged as expected.