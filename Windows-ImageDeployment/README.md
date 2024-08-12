Here’s a complete guide to creating a bootable USB drive using OSDCloud and Windows Configuration Designer (WCD) to install the NinjaOne agent during the Windows provisioning process. This guide includes all the corrected and necessary steps:

### **Step 1: Prepare Your Environment**

**Skipping The OOBE Using unattend.xml**
- You could use the cookbook located here:
[Unattennded install xml Generator:](https://schneegans.de/windows/unattend-generator/)

- You could also use the included file in this repo. Here’s a clear list of all the values in the `unattend.xml` file that you will need to customize:

### Customization Instructions:
1. Replace `examplepassword123` with your desired user password.
2. Replace `ExampleUser` with the desired username.
3. Replace `Primary User Account` with a description for the user account (optional).
4. Replace `John Doe` with the registered owner name.
5. Replace `ExampleCorp` with the registered organization name (optional).

This ensures that the `unattend.xml` is tailored to your specific deployment needs.
#### **Install Prerequisites**
1. **Windows Assessment and Deployment Kit (ADK)**:
   - Download and install the Windows ADK from the [official Microsoft site](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install).

2. **WinPE Add-on**:
   - Install the Windows PE add-on, which provides the necessary tools for creating the WinPE environment.

3. **Install Windows Configuration Designer**:
   

4. **Visual Studio Code with PowerShell Extension**:
   - Download and install [VS Code](https://code.visualstudio.com/) and the PowerShell extension from the Extensions Marketplace.

#### **Prepare the USB Drive**
- Ensure you have a USB drive with at least 32 GB of space.
- Insert the USB drive into your computer.

### **Step 2: Create a Bootable USB with OSDCloud**

#### **Set Up the OSDCloud Workspace**
1. **Run PowerShell Script New-NinjaWinPeUsb.ps1**:
 - This will create the usb where you will place your customization files

 **Customize WinPE**:
   - If you need to customize the WinPE environment further, by accessing a different config script, you edit the line that reads:
     ```powershell
     Edit-OSDCloudwinPE -workspacepath C:\OSDCloud -CloudDriver * -WebPSScript <config URl> -Verbose
     ```

### **Step 3: Prepare the NinjaOne Agent**

1. **Create Folder Structure on WinPE Partition**:
   - Open the ` WinPE (<letterDrive>:)` drive partition and create the following folder structure:
     ```plaintext
     <letterDrive>:\OSDCloud\Automate\Provisioning\
     ```
   - Copy MSI file into the `Provisioning` folder:
     ```plaintext
     <letterDrive>:\OSDCloud\Automate\installer.msi
     ```

### **Step 4: Create the Provisioning Package with WCD**

1. **Launch Windows Configuration Designer**:
   - Open Windows Configuration Designer from the Start menu.

2. **Start a New Project**:
   - Choose **Provision desktop devices**.
   - Provide a name and location for the project.

3. **Set Up the Device**:
   - Navigate through the wizard and configure device settings, network settings, and account management as needed.

4. **Add the Apps**:
   - In the **Add applications** section, add the app:
     - Application Name: `App Name`
     - Installer Path: `C:\Path\To\Installer\installer.msi`
     - ContinueInstall: True
     - RestartRequired: False

5. **Export the Provisioning Package**:
   - Copy the provisioning package to the the same folder as the installer msi one the USB.

### **Step 5: Boot and Deploy**

1. **Boot the Target Device**:
   - Insert the USB drive into the target device and boot from the USB (usually by pressing F12 during startup).

2. **Zero-Touch Provisioning**:
   - The device will boot into WinPE, automatically load the provisioning package, and install Windows along with the NinjaOne agent.

3. **Complete the Setup**:
   - After the installation, Windows will be configured according to the settings in your provisioning package, including the installation of the NinjaOne agent.

### **Summary**
This process ensures that you have a fully automated and streamlined deployment setup. By integrating OSDCloud and WCD, you can provision devices efficiently, with the NinjaOne agent installed as part of the setup. This approach helps minimize manual intervention and ensures consistency across devices.

If you follow these steps closely, you should be able to create a bootable USB that provisions Windows and installs the NinjaOne agent on any compatible device. Let me know if you encounter any issues or need further assistance!


