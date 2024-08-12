Here’s a complete guide to creating a bootable USB drive using OSDCloud and Windows Configuration Designer (WCD) to install the NinjaOne agent during the Windows provisioning process. This guide includes all the corrected and necessary steps:

### **Step 1: Prepare Your Environment**
[Unattennded install xml Generator:](https://schneegans.de/windows/unattend-generator/)
#### **Install Prerequisites**
1. **Windows Assessment and Deployment Kit (ADK)**:
   - Download and install the Windows ADK from the [official Microsoft site](https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install).

2. **WinPE Add-on**:
   - Install the Windows PE add-on, which provides the necessary tools for creating the WinPE environment.

3. **Install Windows Configuration Designer**:
   - Open PowerShell and run:
     ```powershell
     winget install --id Microsoft.WindowsConfigurationDesigner --source msstore
     ```
   - This installs the Windows Configuration Designer (WCD) needed to create the provisioning package.

4. **Visual Studio Code with PowerShell Extension**:
   - Download and install [VS Code](https://code.visualstudio.com/) and the PowerShell extension from the Extensions Marketplace.

#### **Prepare the USB Drive**
- Ensure you have a USB drive with at least 32 GB of space.
- Insert the USB drive into your computer.

### **Step 2: Create a Bootable USB with OSDCloud**

#### **Set Up the OSDCloud Workspace**
1. **Run PowerShell Commands**:
   - Open PowerShell as an Administrator and run the following commands:
     ```powershell
     Set-ExecutionPolicy RemoteSigned -Force
     Install-Module OSD -Force
     Import-Module OSD -Force
     ```

2. **Create the OSDCloud Workspace**:
   - Set up the workspace by running:
     ```powershell
     New-OSDCloudWorkspace -WorkspacePath C:\OSDCloud
     ```

3. **Create the Bootable USB Drive**:
   - Run the following command to create a bootable USB:
     ```powershell
     New-OSDCloudUSB -WorkspacePath C:\OSDCloud
     ```

4. **Customize WinPE**:
   - If you need to customize the WinPE environment further, you can use:
     ```powershell
     Edit-OSDCloudwinPE -workspacepath C:\OSDCloud -CloudDriver * -WebPSScript https://gist.githubusercontent.com/Jeffhunter88/ed338a1c3aab4ca6abd2dd68a329d53c/raw/osdcloud_config.ps1 -Verbose
     ```

### **Step 3: Prepare the NinjaOne Agent**

1. **Create Folder Structure on WinPE Partition**:
   - Open the ` OSDCloudUSB (<letterDrive>:)` drive and create the following folder structure:
     ```plaintext
     <letterDrive>:\OSDCloud\Automate\Provisioning\
     ```
   - Copy the NinjaOne agent MSI file into the `Provisioning` folder:
     ```plaintext
     <letterDrive>:\OSDCloud\Automate\Provisioning\Ninjatechmainoffice6f5c6e-5.9.9652-windows-installer.msi
     ```

### **Step 4: Create the Provisioning Package with WCD**

1. **Launch Windows Configuration Designer**:
   - Open Windows Configuration Designer from the Start menu.

2. **Start a New Project**:
   - Choose **Provision desktop devices**.
   - Provide a name and location for the project.

3. **Set Up the Device**:
   - Navigate through the wizard and configure device settings, network settings, and account management as needed.

4. **Add the NinjaOne Agent**:
   - In the **Add applications** section, add the NinjaOne agent:
     - Application Name: `NinjaOne Agent`
     - Installer Path: `<letterDrive>:\Automate\Provisioning\Ninjatechmainoffice6f5c6e-5.9.9652-windows-installer.msi`
   - Complete the rest of the configuration and save the package.

5. **Export the Provisioning Package**:
   - Save the provisioning package to the root of the WinPE partition on your USB drive.

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
