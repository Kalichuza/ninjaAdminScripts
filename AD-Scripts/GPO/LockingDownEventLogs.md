To restrict access to PowerShell event logs such that only domain or local administrators can view them, you can configure these settings through Group Policy using the Security Descriptor Definition Language (SDDL). Here’s how you can do it:

### Steps to Restrict Access via Group Policy:

1. **Open the Group Policy Management Console (GPMC)**:
   - Run `gpmc.msc` to open the console.

2. **Create or Edit a GPO**:
   - Create a new GPO or edit an existing one that targets the computers where you want to restrict access.

3. **Navigate to Event Log Settings**:
   - Go to `Computer Configuration` > `Policies` > `Administrative Templates` > `Windows Components` > `Event Log Service`.

4. **Select the Specific Event Log**:
   - Choose the specific log you want to secure, such as **Application**, **System**, or **Security**. For example, for the PowerShell Operational log, you would find it under `Microsoft-Windows-PowerShell/Operational`.

5. **Configure Log Security**:
   - Double-click on **Configure log access** and input your SDDL string. This string specifies which users or groups have access to the logs.
   - A common SDDL string for allowing only administrators might look like this:
     ```
     O:BAG:SYD:(A;;0x7;;;BA)(A;;0x3;;;SY)
     ```
     This string allows full access to administrators (BA) and system (SY), and denies access to all others.

6. **Apply the GPO**:
   - Link the GPO to the appropriate Organizational Unit (OU) or domain.

### Important Considerations:
- **Testing**: Before applying this GPO broadly, it’s important to test it on a subset of machines to ensure that the configuration behaves as expected.
- **Registry Changes**: For logs that aren’t directly configurable through the Administrative Templates, you might need to use Group Policy Preferences to push registry changes that modify the `CustomSD` value under the appropriate registry keys.

By following these steps, you can ensure that access to the PowerShell event logs is restricted to authorized users, thereby enhancing security.

For more detailed information, you can refer to Microsoft’s official documentation and other trusted sources like SDM Software【15†source】【16†source】.