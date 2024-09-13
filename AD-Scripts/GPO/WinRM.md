Yes, you can ensure that all managed computers in your domain have **Windows Remote Management (WinRM)** enabled, along with the necessary firewall rules, using **Group Policy (GPO)**. This method allows you to centrally enforce these settings across all the endpoints in your environment.

Here’s how to configure this via Group Policy:

### 1. **Enable WinRM Service via GPO**

You can configure the WinRM service to start automatically on all computers using GPO.

#### Steps to Enable WinRM Service via GPO:

1. **Open Group Policy Management Console (GPMC)**:
   - Open `Group Policy Management` by typing `gpmc.msc` in the `Run` dialog (Windows Key + R).

2. **Create or Edit a GPO**:
   - Create a new GPO (or edit an existing one) that applies to the computers where you want to enable WinRM.
   - Right-click on the relevant **Group Policy Object (GPO)** and select **Edit**.

3. **Navigate to the WinRM Settings**:
   ```
   Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Service
   ```

4. **Configure the WinRM Service**:
   - **Allow Remote Server Management through WinRM**: Set this to **Enabled**.
   - **Set the Start Automatically Policy**: Ensure that WinRM starts automatically by enabling the policy:
     ```
     Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Service > Allow automatic configuration of listeners
     ```

### 2. **Enable the Necessary Firewall Rules via GPO**

You can enable the required firewall rules (TCP 5985) to allow WinRM traffic by configuring firewall settings through GPO.

#### Steps to Enable Firewall Rules via GPO:

1. **Navigate to the Windows Firewall Settings**:
   In the same GPO editor:
   ```
   Computer Configuration > Policies > Windows Settings > Security Settings > Windows Defender Firewall with Advanced Security > Inbound Rules
   ```

2. **Create a New Rule for WinRM (Port 5985)**:
   - Right-click **Inbound Rules** and choose **New Rule**.
   - Select **Predefined** and choose **Windows Remote Management**.
   - Enable the rules for **Windows Remote Management (HTTP-In)** for Domain, Private, and Public profiles.
   
3. **Ensure the Firewall Rule is Enabled**:
   - Make sure that the firewall rules you configure are set to **Allow** traffic, not **Block**.
   - Ensure that the rules are applied to the correct network profiles (Domain, Private, Public) based on your environment.

### 3. **Automate WinRM Listener Configuration via GPO**

You can also configure the WinRM listener settings to ensure they are correctly set up on all managed computers.

#### Steps to Configure WinRM Listener:

1. **Navigate to Listener Configuration**:
   ```
   Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Client
   ```

2. **Allow Basic Authentication** (if necessary):
   If you’re using basic authentication (less secure), enable this:
   - Enable the policy **Allow Basic authentication**.

3. **Configure Trusted Hosts** (if necessary):
   If you need to add remote computers to the TrustedHosts list (for computers outside the domain), you can configure it via:
   ```
   Computer Configuration > Policies > Administrative Templates > Windows Components > Windows Remote Management (WinRM) > WinRM Client > Trusted Hosts
   ```

### 4. **Deploy the GPO**

1. **Link the GPO to the Relevant OU**:
   - After configuring the necessary settings, link the GPO to the Organizational Unit (OU) that contains the computers where you want to apply the settings.

2. **Force Group Policy Update**:
   - Run `gpupdate /force` on the target computers or allow the Group Policy to refresh during the next logon or system restart.

### 5. **Verify the Configuration on Endpoints**

After applying the GPO, you can verify that WinRM is enabled and the firewall rules are active on managed computers by using the following PowerShell commands:

```powershell
# Check if WinRM is running
Get-Service WinRM

# Check if the listener is configured
winrm enumerate winrm/config/listener

# Check if firewall rules are enabled
Get-NetFirewallRule -DisplayGroup "Windows Remote Management"
```

### Conclusion:

By configuring these settings via **GPO**, you can ensure that WinRM is enabled and properly configured on all your managed computers. This approach will help maintain consistency across the environment and make remote management much easier.
