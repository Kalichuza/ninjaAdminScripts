To enforce the use of more secure versions of NTLM (specifically NTLMv2) and disable the older, less secure versions, you can make changes to the Group Policy settings in your Active Directory environment or use a local security policy on individual machines.

Here is a step-by-step guide to configure NTLM settings through Group Policy:

### Step 1: Open Group Policy Management Console
1. Open the **Group Policy Management Console (GPMC)** on your domain controller.
2. Navigate to your domain's Group Policy Objects and either create a new GPO or edit an existing one that is applied to the target computers.

### Step 2: Configure NTLM Security Settings
1. In the Group Policy Management Editor, navigate to the following path:
   ```
   Computer Configuration -> Windows Settings -> Security Settings -> Local Policies -> Security Options
   ```
2. Find and configure the following settings:
   
   - **Network Security: LAN Manager authentication level**  
     Set this policy to:
     ```
     Send NTLMv2 response only. Refuse LM & NTLM
     ```
     This setting ensures that only NTLMv2 responses are sent, and both LM and NTLM responses are refused.

   - **Network Security: Minimum session security for NTLM SSP based (including secure RPC) clients**  
     Set this policy to:
     ```
     Require NTLMv2 session security, Require 128-bit encryption
     ```

   - **Network Security: Minimum session security for NTLM SSP based (including secure RPC) servers**  
     Set this policy to:
     ```
     Require NTLMv2 session security, Require 128-bit encryption
     ```

### Step 3: Apply the Group Policy
1. Once the changes are made, close the Group Policy Management Editor.
2. Link the GPO to the appropriate Organizational Unit (OU) or domain to apply it to the target computers.
3. Force the Group Policy update on client machines using the following command:
   ```
   gpupdate /force
   ```

### Step 4: Verify NTLM Settings
To verify that NTLMv2 is being enforced, you can use the command:
```cmd
nltest /sc_query:yourdomain
```
This command checks the secure channel connection, which should now only accept NTLMv2 or higher if your configuration was successful.

### Step 5: Auditing NTLM Authentication (Optional)
You might want to enable auditing of NTLM authentications to identify any legacy systems still using NTLM or LM protocols. This can help identify systems that need updates or reconfiguration.

1. Navigate to:
   ```
   Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Advanced Audit Policy Configuration -> System Audit Policies -> Logon/Logoff
   ```
2. Enable the following policy:
   ```
   Audit NTLM authentication in this domain
   ```

### Additional Security Considerations
- **Disable NTLM Where Possible**: If your environment supports Kerberos, it's recommended to disable NTLM entirely for maximum security.
- **Update Legacy Systems**: Ensure all systems and applications in your environment support NTLMv2 or Kerberos.

Applying these settings will help secure your network by enforcing more secure NTLMv2 authentication and refusing less secure versions.
