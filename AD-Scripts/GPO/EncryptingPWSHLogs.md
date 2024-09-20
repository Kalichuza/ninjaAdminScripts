Here's how to set up **Protected Event Logging**, **Just Enough Administration (JEA)**, and **Code Signing**:

### 2. **Setting Up Protected Event Logging**

Protected Event Logging encrypts event logs, ensuring they can't be read without the decryption key. Here's how to set it up:

1. **Generate a Certificate for Encryption**:
   You need a certificate for encrypting the event logs, typically issued by your internal CA. If you don’t have one, you can create a self-signed certificate.

   ```powershell
   New-SelfSignedCertificate -DnsName "YourDomain.com" -CertStoreLocation "Cert:\LocalMachine\My"
   ```

2. **Export the Public Key**:
   Export the certificate to deploy to systems that will be logging events.

   ```powershell
   $cert = Get-ChildItem -Path "Cert:\LocalMachine\My" | Where-Object { $_.Subject -like "*YourDomain*" }
   Export-Certificate -Cert $cert -FilePath "C:\path\to\your\certfile.cer"
   ```

3. **Install the Certificate on All Systems**:
   Install the public key on all systems from which you want to protect event logs. You can do this via Group Policy or manually:

   ```powershell
   Import-Certificate -FilePath "C:\path\to\your\certfile.cer" -CertStoreLocation "Cert:\LocalMachine\My"
   ```

4. **Configure Protected Event Logging via Group Policy**:
   Use Group Policy to enable Protected Event Logging:

   - Open `Group Policy Management`.
   - Navigate to **Computer Configuration > Administrative Templates > Windows Components > Event Logging > Enable Protected Event Logging**.
   - Set the policy to **Enabled** and specify the public key certificate you exported.

5. **Decrypting Event Logs**:
   To read the encrypted event logs, the reader will need access to the private key associated with the certificate. You can export the private key for admins who will need to read the logs.

### 4. **Setting Up Just Enough Administration (JEA)**

JEA restricts PowerShell commands that can be executed by users based on role capabilities. Here's how to set it up:

1. **Create a JEA Configuration File**:
   Use the `New-PSSessionConfigurationFile` cmdlet to create a PowerShell session configuration file:

   ```powershell
   New-PSSessionConfigurationFile -Path 'C:\JEA\MyJEAConfig.pssc' -SessionType RestrictedRemoteServer -TranscriptDirectory 'C:\Transcripts'
   ```

   This creates a basic session configuration file with restrictions. Customize the file to define specific roles and what commands each role can run.

2. **Create a Role Capability File**:
   Define which commands, functions, and scripts users can run within the JEA session by creating a role capability file. Install the `PowerShell` module to help with this:

   ```powershell
   New-PSRoleCapabilityFile -Path 'C:\Program Files\WindowsPowerShell\Modules\MyJEAModule\RoleCapabilities\MyAdminRole.psrc'
   ```

   Customize the file with the commands and cmdlets you want to allow. For example:

   ```powershell
   VisibleCmdlets = 'Get-Service', 'Restart-Service'
   ```

3. **Register the JEA Session**:
   Register the session configuration to make it available for remote PowerShell connections:

   ```powershell
   Register-PSSessionConfiguration -Name MyJEASession -Path 'C:\JEA\MyJEAConfig.pssc' -Force
   ```

4. **Connect to the JEA Session**:
   Users can connect to this restricted session using:

   ```powershell
   Enter-PSSession -ComputerName MyServer -ConfigurationName MyJEASession
   ```

   They will be limited to the commands and roles defined in the configuration.

### 6. **Setting Up Code Signing for PowerShell Scripts**

1. **Obtain or Generate a Code Signing Certificate**:
   If your organization has a certificate authority (CA), request a code-signing certificate. You can also generate a self-signed certificate for testing purposes:

   ```powershell
   New-SelfSignedCertificate -DnsName "YourDomain.com" -CertStoreLocation "Cert:\LocalMachine\My" -Type CodeSigningCert
   ```

2. **Export the Code Signing Certificate**:
   Export the certificate so you can sign scripts on other systems.

   ```powershell
   Export-PfxCertificate -Cert "Cert:\LocalMachine\My\<Thumbprint>" -FilePath "C:\path\to\cert.pfx" -Password (ConvertTo-SecureString -String "your_password" -Force -AsPlainText)
   ```

3. **Sign PowerShell Scripts**:
   Once you have the certificate, you can sign your scripts using the `Set-AuthenticodeSignature` cmdlet:

   ```powershell
   Set-AuthenticodeSignature -FilePath "C:\path\to\your\script.ps1" -Certificate (Get-ChildItem -Path "Cert:\CurrentUser\My" | Where-Object { $_.Subject -match "YourDomain.com" })
   ```

4. **Enforce Script Signing Policy**:
   Set the execution policy to require signed scripts:

   ```powershell
   Set-ExecutionPolicy AllSigned -Scope LocalMachine
   ```

   This ensures only signed scripts are executed on your systems.

---

By following these steps, you'll enhance security for your PowerShell transcripts and logging.