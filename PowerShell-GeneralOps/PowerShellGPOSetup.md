To import `.admx` templates for PowerShell Core into Group Policy, follow these steps:

### Step 1: Download the PowerShell Core ADMX Templates
1. Go to the official [PowerShell GitHub repository](https://github.com/PowerShell/PowerShell).
2. Look for the `PolicyFile` folder under the desired release version.
3. Download the `.admx` and `.adml` files for PowerShell Core.

### Step 2: Copy the ADMX and ADML Files
#### Option 1: Import to Local Group Policy (Single Machine)
1. Copy the `.admx` file(s) to the following location:
   ```bash
   C:\Windows\PolicyDefinitions\
   ```
2. Copy the corresponding `.adml` language file (e.g., `en-US.adml`) to the following directory:
   ```bash
   C:\Windows\PolicyDefinitions\en-US\
   ```

#### Option 2: Import to Central Store (For a Domain Environment)
1. On the domain controller, navigate to the SYSVOL folder:
   ```bash
   \\<domain>\SYSVOL\<domain>\Policies\
   ```
2. If the `PolicyDefinitions` folder does not already exist in the `Policies` folder, create it.
3. Copy the `.admx` file(s) to:
   ```bash
   \\<domain>\SYSVOL\<domain>\Policies\PolicyDefinitions\
   ```
4. Copy the corresponding `.adml` file(s) (e.g., `en-US.adml`) to:
   ```bash
   \\<domain>\SYSVOL\<domain>\Policies\PolicyDefinitions\en-US\
   ```

### Step 3: Open Group Policy Management Editor
1. Launch the **Group Policy Management Console (GPMC)**.
2. Create or edit a Group Policy Object (GPO).
3. Navigate to **Computer Configuration** or **User Configuration** > **Administrative Templates**.
4. Verify that the newly imported PowerShell Core templates are available.

Once the templates are imported, you can configure PowerShell Core policies according to your requirements.
