# Creating and Deploying a Custom Windows Image

This guide provides step-by-step instructions to create and deploy a custom Windows image with preinstalled software and settings.

## Prerequisites

1. A reference computer with a clean installation of Windows.
2. Required software and drivers installed on the reference computer.
3. Windows ADK (Assessment and Deployment Kit) and Windows PE add-on.

## Step 1: Prepare the Reference Computer

1. **Install Windows**:
   - Start with a clean installation of Windows on a reference computer.

2. **Install Software and Configure Settings**:
   - Install all the necessary applications and configure the system settings as required.
   - Update Windows and install drivers.

3. **Create Default User Profile**:
   - Configure the user profile with default settings.
   - Copy the configured profile to the default user profile:
     ```powershell
     Copy-Item -Recurse -Force "C:\Users\YourUserProfile" "C:\Users\Default"
     ```

## Step 2: Generalize the System

1. **Open Command Prompt as Administrator**:
   - Run the Sysprep tool to generalize the system.
     ```powershell
     C:\Windows\System32\Sysprep\sysprep.exe /oobe /generalize /shutdown
     ```
   - The system will shut down after the process is complete.

## Step 3: Capture the Image

### 3.1: Download and Install Windows ADK and Windows PE Add-on

1. **Download Windows ADK**:
   - [Download the Windows ADK 10.1.26100.1 (May 2024)](https://go.microsoft.com/fwlink/?linkid=2166081).
   - Run the installer and select the required components (especially "Deployment Tools").

2. **Download Windows PE Add-on**:
   - [Download the Windows PE add-on for the Windows ADK 10.1.26100.1 (May 2024)](https://go.microsoft.com/fwlink/?linkid=2166164).
   - Run the installer to add the Windows PE components to your ADK installation.

### 3.2: Create a Bootable Windows PE USB Drive

1. **Open the Deployment and Imaging Tools Environment as Administrator**:
   - From the Start menu, open the "Deployment and Imaging Tools Environment" as an administrator.

2. **Create Windows PE Media**:
   - Create a working directory for Windows PE files:
     ```powershell
     copype.cmd amd64 C:\WinPE_amd64
     ```
   - Copy Windows PE files to the USB drive:
     ```powershell
     MakeWinPEMedia /UFD C:\WinPE_amd64 E:
     ```
     Replace `E:` with the drive letter of your USB drive.

### 3.3: Boot the Reference Computer with Windows PE USB Drive

1. **Boot the Reference Computer**:
   - Insert the bootable Windows PE USB drive into the reference computer.
   - Boot the computer from the USB drive. This usually involves pressing a key like F12, F2, or Esc during startup to select the boot device.

2. **Capture the Image Using DISM**:
   - Once booted into Windows PE, you will see a command prompt.
   - Use the `DISM` tool to capture the Windows image:
     ```powershell
     dism /capture-image /imagefile:D:\CustomImage.wim /capturedir:C:\ /name:"Custom Windows Image" /description:"Custom Windows Image with Preinstalled Software"
     ```
     - **/imagefile**: The path where the captured image will be saved. Replace `D:\CustomImage.wim` with the desired path (e.g., an external USB drive).
     - **/capturedir**: The drive you want to capture, usually `C:\`.
     - **/name**: A name for the image.
     - **/description**: A description for the image.

3. **Wait for the Process to Complete**:
   - The DISM tool will now capture the image of your reference computer and save it to the specified location. This process may take some time depending on the size of the installation.

## Step 4: Deploy the Image

1. **Prepare Deployment Media**:
   - Create a bootable USB drive with the Windows installation files.
   - Copy the custom image (`CustomImage.wim`) to the `sources` folder on the USB drive, replacing the existing `install.wim`.

2. **Deploy the Image to New PCs**:
   - Boot the target PC with the bootable USB drive.
   - Follow the installation prompts, which will use the custom image for installation.

## Step 5: Automate with Answer Files (Optional)

1. **Create an Answer File**:
   - Use Windows System Image Manager (WSIM) to create an answer file (`unattend.xml`) for automated installation.

2. **Place the Answer File**:
   - Copy the `unattend.xml` file to the `sources` folder on the bootable USB drive.

## Tools Required

- Windows ADK (for Windows PE and WSIM)
- Sysprep (built into Windows)
- DISM (Deployment Image Servicing and Management tool)

By following these steps, you can create a custom Windows image tailored to your MSP's needs, streamlining the deployment process for new PCs with preinstalled software and configured settings.
